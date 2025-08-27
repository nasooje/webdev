from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import and_, or_, desc, func
from typing import List, Optional
from pydantic import BaseModel
from jinja2 import Template
from database import get_db
from models import Discussion, DiscussionComment, DiscussionReaction, CommentReaction, Stock, User, ReactionType
from routers.auth import get_current_user 
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

class DiscussionCreate(BaseModel):
    title: str
    content: str

class CommentCreate(BaseModel):
    content: str
    parent_id: Optional[int] = None

class ReactionCreate(BaseModel):
    reaction_type: str

class PreviewRequest(BaseModel):
    title: str
    content: str
    advanced_formatting: Optional[bool] = False

@router.get("/stock/{stock_code}")
async def get_discussions(
    stock_code: str,
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    sort_by: str = Query("latest", description="latest, popular, views"),
    db: Session = Depends(get_db)
):
    try:
        stock = db.query(Stock).filter(Stock.code == stock_code).first()
        if not stock:
            raise HTTPException(status_code=404, detail="주식 종목을 찾을 수 없습니다.")
        
        query = db.query(Discussion).filter(Discussion.stock_id == stock.id)
        
        if sort_by == "popular":
            query = query.order_by(desc(Discussion.likes_count))
        elif sort_by == "views":
            query = query.order_by(desc(Discussion.views))
        else: 
            query = query.order_by(desc(Discussion.created_at))
        
        offset = (page - 1) * limit
        discussions = query.offset(offset).limit(limit).options(
            joinedload(Discussion.user),
            joinedload(Discussion.stock)
        ).all()
        
        total = db.query(Discussion).filter(Discussion.stock_id == stock.id).count()
        
        return {
            "discussions": discussions,
            "total": total,
            "page": page,
            "limit": limit,
            "total_pages": (total + limit - 1) // limit
        }
        
    except Exception as e:
        logger.error(f"토론실 목록 조회 오류: {e}")
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.get("/post/{discussion_id}")
async def get_discussion(
    discussion_id: int,
    db: Session = Depends(get_db)
):
    try:
        discussion = db.query(Discussion).options(
            joinedload(Discussion.user),
            joinedload(Discussion.stock),
            joinedload(Discussion.comments).joinedload(DiscussionComment.user),
            joinedload(Discussion.comments).joinedload(DiscussionComment.replies).joinedload(DiscussionComment.user)
        ).filter(Discussion.id == discussion_id).first()
        
        if not discussion:
            raise HTTPException(status_code=404, detail="게시글을 찾을 수 없습니다.")
        
        discussion.views += 1
        db.commit()
        
        return {
            "discussion": discussion,
            "comments": discussion.comments
        }
        
    except Exception as e:
        logger.error(f"게시글 상세 조회 오류: {e}")
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.post("/stock/{stock_code}")
async def create_discussion(
    stock_code: str,
    discussion_data: DiscussionCreate,
    current_user: User = Depends(get_current_user),  
    db: Session = Depends(get_db)
):
    try:
        stock = db.query(Stock).filter(Stock.code == stock_code).first()
        if not stock:
            raise HTTPException(status_code=404, detail="주식 종목을 찾을 수 없습니다.")
        
        discussion = Discussion(
            stock_id=stock.id,
            user_id=current_user.id,  
            title=discussion_data.title,
            content=discussion_data.content
        )
        
        db.add(discussion)
        db.commit()
        db.refresh(discussion)
        
        return {"message": "게시글이 작성되었습니다.", "discussion_id": discussion.id}
        
    except Exception as e:
        logger.error(f"게시글 작성 오류: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.post("/post/{discussion_id}/comments")
async def create_comment(
    discussion_id: int,
    comment_data: CommentCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        discussion = db.query(Discussion).filter(Discussion.id == discussion_id).first()
        if not discussion:
            raise HTTPException(status_code=404, detail="게시글을 찾을 수 없습니다.")
        
        if comment_data.parent_id:
            parent_comment = db.query(DiscussionComment).filter(
                DiscussionComment.id == comment_data.parent_id,
                DiscussionComment.discussion_id == discussion_id
            ).first()
            if not parent_comment:
                raise HTTPException(status_code=404, detail="부모 댓글을 찾을 수 없습니다.")
        
        comment = DiscussionComment(
            discussion_id=discussion_id,
            user_id=current_user.id, 
            content=comment_data.content,
            parent_id=comment_data.parent_id
        )
        
        db.add(comment)
        
        discussion.comments_count += 1
        
        db.commit()
        db.refresh(comment)
        
        return {"message": "댓글이 작성되었습니다.", "comment_id": comment.id}
        
    except Exception as e:
        logger.error(f"댓글 작성 오류: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.post("/post/{discussion_id}/reaction")
async def react_to_discussion(
    discussion_id: int,
    reaction_data: ReactionCreate,
    current_user: User = Depends(get_current_user),  
    db: Session = Depends(get_db)
):
    try:
        discussion = db.query(Discussion).filter(Discussion.id == discussion_id).first()
        if not discussion:
            raise HTTPException(status_code=404, detail="게시글을 찾을 수 없습니다.")
        
        if reaction_data.reaction_type not in ['like', 'dislike']:
            raise HTTPException(status_code=400, detail="잘못된 반응 타입입니다.")
        
        existing_reaction = db.query(DiscussionReaction).filter(
            DiscussionReaction.user_id == current_user.id,  
            DiscussionReaction.discussion_id == discussion_id
        ).first()
        
        if existing_reaction:
            if existing_reaction.reaction_type.value == reaction_data.reaction_type:
                db.delete(existing_reaction)
                if reaction_data.reaction_type == 'like':
                    discussion.likes_count = max(0, discussion.likes_count - 1)
                else:
                    discussion.dislikes_count = max(0, discussion.dislikes_count - 1)
                message = "반응이 취소되었습니다."
            else:
                old_type = existing_reaction.reaction_type.value
                existing_reaction.reaction_type = ReactionType(reaction_data.reaction_type)
                
                if old_type == 'like':
                    discussion.likes_count = max(0, discussion.likes_count - 1)
                    discussion.dislikes_count += 1
                else:
                    discussion.dislikes_count = max(0, discussion.dislikes_count - 1)
                    discussion.likes_count += 1
                message = "반응이 변경되었습니다."
        else:
            new_reaction = DiscussionReaction(
                user_id=current_user.id,
                discussion_id=discussion_id,
                reaction_type=ReactionType(reaction_data.reaction_type)
            )
            db.add(new_reaction)
            
            if reaction_data.reaction_type == 'like':
                discussion.likes_count += 1
            else:
                discussion.dislikes_count += 1
            message = "반응이 등록되었습니다."
        
        db.commit()
        
        return {
            "message": message,
            "likes_count": discussion.likes_count,
            "dislikes_count": discussion.dislikes_count
        }
        
    except Exception as e:
        logger.error(f"게시글 반응 오류: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.post("/comment/{comment_id}/reaction")
async def react_to_comment(
    comment_id: int,
    reaction_data: ReactionCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        comment = db.query(DiscussionComment).filter(DiscussionComment.id == comment_id).first()
        if not comment:
            raise HTTPException(status_code=404, detail="댓글을 찾을 수 없습니다.")
        
        if reaction_data.reaction_type not in ['like', 'dislike']:
            raise HTTPException(status_code=400, detail="잘못된 반응 타입입니다.")
        
        existing_reaction = db.query(CommentReaction).filter(
            CommentReaction.user_id == current_user.id,
            CommentReaction.comment_id == comment_id
        ).first()
        
        if existing_reaction:
            if existing_reaction.reaction_type.value == reaction_data.reaction_type:
                db.delete(existing_reaction)
                if reaction_data.reaction_type == 'like':
                    comment.likes_count = max(0, comment.likes_count - 1)
                else:
                    comment.dislikes_count = max(0, comment.dislikes_count - 1)
                message = "반응이 취소되었습니다."
            else:
                old_type = existing_reaction.reaction_type.value
                existing_reaction.reaction_type = ReactionType(reaction_data.reaction_type)
                
                if old_type == 'like':
                    comment.likes_count = max(0, comment.likes_count - 1)
                    comment.dislikes_count += 1
                else:
                    comment.dislikes_count = max(0, comment.dislikes_count - 1)
                    comment.likes_count += 1
                message = "반응이 변경되었습니다."
        else:
            new_reaction = CommentReaction(
                user_id=current_user.id,
                comment_id=comment_id,
                reaction_type=ReactionType(reaction_data.reaction_type)
            )
            db.add(new_reaction)
            
            if reaction_data.reaction_type == 'like':
                comment.likes_count += 1
            else:
                comment.dislikes_count += 1
            message = "반응이 등록되었습니다."
        
        db.commit()
        
        return {
            "message": message,
            "likes_count": comment.likes_count,
            "dislikes_count": comment.dislikes_count
        }
        
    except Exception as e:
        logger.error(f"댓글 반응 오류: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.post("/preview", response_class=HTMLResponse)
async def preview_discussion(
    preview_data: PreviewRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        content = preview_data.content
        title = preview_data.title
        
        template_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <title>미리보기: {title}</title>
            <style>
                body {{ font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }}
                .preview-container {{ background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
                .title {{ color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }}
                .content {{ margin-top: 20px; line-height: 1.6; white-space: pre-wrap; }}
                .user-info {{ color: #7f8c8d; font-size: 12px; margin-top: 20px; }}
            </style>
        </head>
        <body>
            <div class="preview-container">
                <h1 class="title">{title}</h1>
                <div class="content">{content}</div>
                <div class="user-info">작성자: {{{{ username }}}} | 미리보기 시간: {{{{ current_time }}}}</div>
            </div>
        </body>
        </html>
        """

        from datetime import datetime
        template = Template(template_content)
        
        html_content = template.render(
            title=title,
            content=content,
            username=current_user.username,
            current_time=datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            lipsum=None,
            range=range,
            len=len,
            str=str,
            dict=dict,
            list=list
        )
        
        return HTMLResponse(content=html_content)
        
    except Exception as e:
        logger.error(f"미리보기 생성 오류: {e}")
        return HTMLResponse(
            content=f"<html><body><h1>미리보기 오류</h1><p>오류: {str(e)}</p></body></html>",
            status_code=500
        )

@router.post("/format-template")
async def format_template(
    template: str = Query(..., description="사용자 정의 템플릿"),
    title: str = Query(default="테스트 제목", description="제목"),
    content: str = Query(default="테스트 내용", description="내용"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        jinja_template = Template(template)
        result = jinja_template.render(
            title=title,
            content=content,
            username=current_user.username,
            user_id=current_user.id,
            __builtins__=__builtins__,
            open=open,
            eval=eval,
            exec=exec
        )
        
        return HTMLResponse(content=result)
        
    except Exception as e:
        return {"error": f"템플릿 렌더링 실패: {str(e)}"} 