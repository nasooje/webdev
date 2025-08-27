import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import { MessageSquare, Eye, ThumbsUp, ThumbsDown, Plus, Send, Reply } from 'lucide-react';
import { discussionsApi, authApi } from '../services/api';

const Container = styled.div`
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
`;

const Header = styled.div`
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  color: white;
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const Title = styled.h2`
  font-size: 20px;
  font-weight: 600;
  margin: 0;
`;

const CreateButton = styled.button`
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 500;
  transition: all 0.2s ease;
  
  &:hover {
    background: rgba(255, 255, 255, 0.3);
  }
`;

const Controls = styled.div`
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const SortButtons = styled.div`
  display: flex;
  gap: 10px;
`;

const SortButton = styled.button<{ $active: boolean }>`
  background: ${props => props.$active ? '#3498db' : '#f8f9fa'};
  color: ${props => props.$active ? 'white' : '#666'};
  border: 1px solid ${props => props.$active ? '#3498db' : '#ddd'};
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s ease;
  
  &:hover {
    background: ${props => props.$active ? '#2980b9' : '#e9ecef'};
  }
`;

const Content = styled.div`
  max-height: 500px;
  overflow-y: auto;
`;

const PostList = styled.div`
  padding: 0;
`;

const PostItem = styled.div`
  padding: 15px 20px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background 0.2s ease;
  
  &:hover {
    background: #f8f9fa;
  }
  
  &:last-child {
    border-bottom: none;
  }
`;

const PostTitle = styled.h3`
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 8px 0;
  line-height: 1.4;
`;

const PostMeta = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #7f8c8d;
  font-size: 12px;
`;

const PostInfo = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
`;

const PostStats = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
`;

const StatItem = styled.div`
  display: flex;
  align-items: center;
  gap: 4px;
`;

const PostDetail = styled.div`
  padding: 20px;
`;

const PostHeader = styled.div`
  border-bottom: 1px solid #eee;
  padding-bottom: 15px;
  margin-bottom: 20px;
`;

const PostContent = styled.div`
  line-height: 1.6;
  color: #2c3e50;
  margin-bottom: 20px;
  white-space: pre-wrap;
`;

const ReactionButtons = styled.div`
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
`;

const ReactionButton = styled.button<{ $active?: boolean; $type: 'like' | 'dislike' }>`
  background: ${props => 
    props.$active 
      ? props.$type === 'like' ? '#d73027' : '#1a73e8'
      : '#f8f9fa'
  };
  color: ${props => props.$active ? 'white' : '#666'};
  border: 1px solid ${props => 
    props.$active 
      ? props.$type === 'like' ? '#d73027' : '#1a73e8'
      : '#ddd'
  };
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  transition: all 0.2s ease;
  
  &:hover {
    background: ${props => 
      props.$type === 'like' ? '#b52d20' : '#1557b0'
    };
    color: white;
  }
`;

const CommentsSection = styled.div`
  border-top: 1px solid #eee;
  padding-top: 20px;
`;

const CommentForm = styled.div`
  margin-bottom: 20px;
`;

const CommentInputSection = styled.div`
  display: flex;
  flex-direction: column;
  gap: 10px;
`;

const CommentButtonContainer = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 10px;
`;

const CommentInput = styled.textarea`
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  resize: vertical;
  min-height: 80px;
  font-family: inherit;
  
  &:focus {
    outline: none;
    border-color: #3498db;
  }
`;

const CommentButton = styled.button`
  background: #3498db;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 6px;
  
  &:hover {
    background: #2980b9;
  }
  
  &:disabled {
    background: #bdc3c7;
    cursor: not-allowed;
  }
`;

const CommentList = styled.div`
  space-y: 15px;
`;

const CommentItem = styled.div<{ $isReply?: boolean }>`
  margin-left: ${props => props.$isReply ? '40px' : '0'};
  padding: 12px;
  background: ${props => props.$isReply ? '#f8f9fa' : '#fff'};
  border: 1px solid #eee;
  border-radius: 6px;
  margin-bottom: 10px;
`;

const CommentHeader = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
`;

const CommentAuthor = styled.span`
  font-weight: 600;
  color: #2c3e50;
`;

const CommentTime = styled.span`
  color: #7f8c8d;
  font-size: 12px;
`;

const CommentContent = styled.div`
  color: #2c3e50;
  line-height: 1.5;
  margin-bottom: 10px;
  white-space: pre-wrap;
`;

const CommentActions = styled.div`
  display: flex;
  gap: 10px;
  align-items: center;
`;

const CommentReactionButton = styled.button<{ $active?: boolean; $type: 'like' | 'dislike' }>`
  background: none;
  border: none;
  color: ${props => 
    props.$active 
      ? props.$type === 'like' ? '#d73027' : '#1a73e8'
      : '#7f8c8d'
  };
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  
  &:hover {
    color: ${props => props.$type === 'like' ? '#d73027' : '#1a73e8'};
  }
`;

const ReplyButton = styled.button`
  background: none;
  border: none;
  color: #7f8c8d;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  
  &:hover {
    color: #3498db;
  }
`;

const CreatePostForm = styled.div`
  padding: 20px;
  border-bottom: 1px solid #eee;
`;

const FormGroup = styled.div`
  margin-bottom: 15px;
`;

const Label = styled.label`
  display: block;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 6px;
`;

const Input = styled.input`
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  
  &:focus {
    outline: none;
    border-color: #3498db;
  }
`;

const TextArea = styled.textarea`
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  min-height: 120px;
  resize: vertical;
  
  &:focus {
    outline: none;
    border-color: #3498db;
  }
`;

const FormButtons = styled.div`
  display: flex;
  gap: 10px;
  justify-content: flex-end;
`;

const SubmitButton = styled.button`
  background: #3498db;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  
  &:hover {
    background: #2980b9;
  }
  
  &:disabled {
    background: #bdc3c7;
    cursor: not-allowed;
  }
`;

const CancelButton = styled.button`
  background: #6c757d;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  
  &:hover {
    background: #5a6268;
  }
`;

const PreviewButton = styled.button`
  background: #f39c12;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  
  &:hover {
    background: #e67e22;
  }
  
  &:disabled {
    background: #bdc3c7;
    cursor: not-allowed;
  }
`;

const PreviewModal = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
`;

const PreviewContent = styled.div`
  background: white;
  border-radius: 10px;
  width: 95%;
  height: 90%;
  min-width: 800px;
  min-height: 600px;
  max-width: 1200px;
  max-height: 900px;
  overflow: auto;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
`;

const PreviewHeader = styled.div`
  padding: 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
`;

const PreviewBody = styled.div`
  flex: 1;
  overflow: auto;
  padding: 0;
`;

const PreviewCloseButton = styled.button`
  background: #e74c3c;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  
  &:hover {
    background: #c0392b;
  }
`;

const EmptyState = styled.div`
  text-align: center;
  padding: 40px 20px;
  color: #7f8c8d;
`;

interface DiscussionBoardProps {
  stockCode: string;
  stockName?: string;
}

interface Discussion {
  id: number;
  title: string;
  content: string;
  views: number;
  likes_count: number;
  dislikes_count: number;
  comments_count: number;
  created_at: string;
  user: {
    username: string;
  };
}

interface Comment {
  id: number;
  content: string;
  likes_count: number;
  dislikes_count: number;
  created_at: string;
  parent_id?: number;
  user: {
    username: string;
  };
  replies?: Comment[];
}

const DiscussionBoard: React.FC<DiscussionBoardProps> = ({ stockCode, stockName }) => {
  const [discussions, setDiscussions] = useState<Discussion[]>([]);
  const [selectedDiscussion, setSelectedDiscussion] = useState<Discussion | null>(null);
  const [comments, setComments] = useState<Comment[]>([]);
  const [sortBy, setSortBy] = useState<'latest' | 'popular' | 'views'>('latest');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [loading, setLoading] = useState(true);
  
  const [newPostTitle, setNewPostTitle] = useState('');
  const [newPostContent, setNewPostContent] = useState('');
  const [newComment, setNewComment] = useState('');
  const [replyTo, setReplyTo] = useState<number | null>(null);
  const [submitting, setSubmitting] = useState(false);
  
  const [showPreview, setShowPreview] = useState(false);
  const [previewContent, setPreviewContent] = useState('');
  const [previewLoading, setPreviewLoading] = useState(false);
  
  const [currentUser, setCurrentUser] = useState<{ id: number; username: string } | null>(null);
  const [userLoading, setUserLoading] = useState(true);

  useEffect(() => {
    fetchCurrentUser();
  }, []);

  useEffect(() => {
    fetchDiscussions();
  }, [stockCode, sortBy]);

  const fetchCurrentUser = async () => {
    try {
      const response = await authApi.getCurrentUser();
      setCurrentUser({
        id: response.data.id,
        username: response.data.username
      });
    } catch (error) {
      console.error('현재 사용자 정보 로딩 오류:', error);
      setCurrentUser({ id: 1, username: 'test' });
    } finally {
      setUserLoading(false);
    }
  };

  const fetchDiscussions = async () => {
    try {
      setLoading(true);
      const response = await discussionsApi.getDiscussions(stockCode, 1, 20, sortBy);
      setDiscussions(response.data.discussions);
    } catch (error) {
      console.error('토론실 목록 로딩 오류:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchDiscussionDetail = async (discussionId: number) => {
    try {
      const response = await discussionsApi.getDiscussion(discussionId);
      setSelectedDiscussion(response.data.discussion);
      setComments(response.data.comments);
    } catch (error) {
      console.error('게시글 상세 로딩 오류:', error);
    }
  };

  const handleCreatePost = async () => {
    if (!newPostTitle.trim() || !newPostContent.trim()) {
      alert('제목과 내용을 모두 입력해주세요.');
      return;
    }

    try {
      setSubmitting(true);
      await discussionsApi.createDiscussion(stockCode, {
        title: newPostTitle,
        content: newPostContent
      });
      
      setNewPostTitle('');
      setNewPostContent('');
      setShowCreateForm(false);
      fetchDiscussions();
      alert('게시글이 작성되었습니다.');
    } catch (error) {
      console.error('게시글 작성 오류:', error);
      alert('게시글 작성에 실패했습니다.');
    } finally {
      setSubmitting(false);
    }
  };

  const handleCreateComment = async () => {
    if (!newComment.trim() || !selectedDiscussion) return;

    try {
      setSubmitting(true);
      await discussionsApi.createComment(selectedDiscussion.id, {
        content: newComment,
        parent_id: replyTo || undefined
      });
      
      setNewComment('');
      setReplyTo(null);
      fetchDiscussionDetail(selectedDiscussion.id);
      alert('댓글이 작성되었습니다.');
    } catch (error) {
      console.error('댓글 작성 오류:', error);
      alert('댓글 작성에 실패했습니다.');
    } finally {
      setSubmitting(false);
    }
  };

  const handlePreview = async () => {
    if (!newPostTitle.trim() || !newPostContent.trim()) {
      alert('제목과 내용을 모두 입력해주세요.');
      return;
    }

    try {
      setPreviewLoading(true);
      const response = await discussionsApi.previewDiscussion({
        title: newPostTitle,
        content: newPostContent
      });
      
      setPreviewContent(response.data);
      setShowPreview(true);
    } catch (error) {
      console.error('미리보기 오류:', error);
      alert('미리보기 생성에 실패했습니다.');
    } finally {
      setPreviewLoading(false);
    }
  };

  const handleReaction = async (discussionId: number, reactionType: 'like' | 'dislike') => {
    try {
      await discussionsApi.reactToDiscussion(discussionId, reactionType);
      if (selectedDiscussion?.id === discussionId) {
        fetchDiscussionDetail(discussionId);
      }
      fetchDiscussions();
    } catch (error) {
      console.error('반응 오류:', error);
    }
  };

  const handleCommentReaction = async (commentId: number, reactionType: 'like' | 'dislike') => {
    try {
      await discussionsApi.reactToComment(commentId, reactionType);
      if (selectedDiscussion) {
        fetchDiscussionDetail(selectedDiscussion.id);
      }
    } catch (error) {
      console.error('댓글 반응 오류:', error);
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);

    if (minutes < 1) return '방금 전';
    if (minutes < 60) return `${minutes}분 전`;
    if (hours < 24) return `${hours}시간 전`;
    if (days < 7) return `${days}일 전`;
    return date.toLocaleDateString('ko-KR');
  };

  const renderComments = (comments: Comment[], parentId: number | null = null) => {
    return comments
      .filter(comment => comment.parent_id === parentId)
      .map(comment => (
        <CommentItem key={comment.id} $isReply={parentId !== null}>
          <CommentHeader>
            <CommentAuthor>{comment.user.username}</CommentAuthor>
            <CommentTime>{formatDate(comment.created_at)}</CommentTime>
          </CommentHeader>
          <CommentContent>{comment.content}</CommentContent>
          <CommentActions>
            <CommentReactionButton 
              $type="like"
              onClick={() => handleCommentReaction(comment.id, 'like')}
            >
              <ThumbsUp size={14} />
              {comment.likes_count}
            </CommentReactionButton>
            <CommentReactionButton 
              $type="dislike"
              onClick={() => handleCommentReaction(comment.id, 'dislike')}
            >
              <ThumbsDown size={14} />
              {comment.dislikes_count}
            </CommentReactionButton>
            {parentId === null && (
              <ReplyButton onClick={() => setReplyTo(comment.id)}>
                <Reply size={14} />
                답글
              </ReplyButton>
            )}
          </CommentActions>
          {renderComments(comments, comment.id)}
        </CommentItem>
      ));
  };

  if (userLoading) {
    return (
      <Container>
        <Header>
          <Title>로딩 중...</Title>
        </Header>
        <Content>
          <EmptyState>사용자 정보를 로딩하고 있습니다...</EmptyState>
        </Content>
      </Container>
    );
  }

  if (!currentUser) {
    return (
      <Container>
        <Header>
          <Title>로그인 필요</Title>
        </Header>
        <Content>
          <EmptyState>토론실을 사용하려면 로그인이 필요합니다.</EmptyState>
        </Content>
      </Container>
    );
  }

  if (selectedDiscussion) {
    return (
      <Container>
        <Header>
          <div>
            <Title>{selectedDiscussion.title}</Title>
            <div style={{ fontSize: '14px', marginTop: '5px', opacity: 0.9 }}>
              {selectedDiscussion.user.username} • {formatDate(selectedDiscussion.created_at)}
            </div>
          </div>
          <CreateButton onClick={() => setSelectedDiscussion(null)}>
            목록으로
          </CreateButton>
        </Header>
        
        <PostDetail>
          <PostContent>{selectedDiscussion.content}</PostContent>
          
          <ReactionButtons>
            <ReactionButton 
              $type="like"
              onClick={() => handleReaction(selectedDiscussion.id, 'like')}
            >
              <ThumbsUp size={16} />
              좋아요 ({selectedDiscussion.likes_count})
            </ReactionButton>
            <ReactionButton 
              $type="dislike"
              onClick={() => handleReaction(selectedDiscussion.id, 'dislike')}
            >
              <ThumbsDown size={16} />
              싫어요 ({selectedDiscussion.dislikes_count})
            </ReactionButton>
          </ReactionButtons>
          
          <CommentsSection>
            <h4>댓글 ({selectedDiscussion.comments_count})</h4>
            
            <CommentForm>
              {replyTo && (
                <div style={{ fontSize: '12px', color: '#666', marginBottom: '5px' }}>
                  댓글에 답글을 작성중입니다. 
                  <button 
                    style={{ background: 'none', border: 'none', color: '#3498db', cursor: 'pointer', marginLeft: '5px' }}
                    onClick={() => setReplyTo(null)}
                  >
                    취소
                  </button>
                </div>
              )}
              <CommentInputSection>
                <CommentInput
                  value={newComment}
                  onChange={(e) => setNewComment(e.target.value)}
                  placeholder="댓글을 입력하세요..."
                />
              </CommentInputSection>
              <CommentButtonContainer>
                <div style={{ fontSize: '14px', color: '#666' }}>
                  {currentUser?.username}로 작성
                </div>
                <CommentButton 
                  onClick={handleCreateComment}
                  disabled={!newComment.trim() || submitting}
                >
                  <Send size={14} />
                  {replyTo ? '답글 작성' : '댓글 작성'}
                </CommentButton>
              </CommentButtonContainer>
            </CommentForm>
            
            <CommentList>
              {renderComments(comments)}
            </CommentList>
          </CommentsSection>
        </PostDetail>
      </Container>
    );
  }

  return (
    <Container>
      <Header>
        <div>
          <Title>{stockName || stockCode} 토론실</Title>
          <div style={{ fontSize: '12px', marginTop: '5px', opacity: 0.8 }}>
            {currentUser?.username}로 로그인됨
          </div>
        </div>
        <CreateButton onClick={() => setShowCreateForm(!showCreateForm)}>
          <Plus size={16} />
          글쓰기
        </CreateButton>
      </Header>

      {showCreateForm && (
        <CreatePostForm>
          <FormGroup>
            <Label>작성자</Label>
            <div style={{ padding: '10px', background: '#f8f9fa', border: '1px solid #ddd', borderRadius: '6px', color: '#666' }}>
              {currentUser?.username}
            </div>
          </FormGroup>
          <FormGroup>
            <Label>제목</Label>
            <Input
              value={newPostTitle}
              onChange={(e) => setNewPostTitle(e.target.value)}
              placeholder="게시글 제목을 입력하세요"
            />
          </FormGroup>
          <FormGroup>
            <Label>내용</Label>
            <TextArea
              value={newPostContent}
              onChange={(e) => setNewPostContent(e.target.value)}
              placeholder="게시글 내용을 입력하세요"
            />
          </FormGroup>
          <FormButtons>
            <CancelButton onClick={() => setShowCreateForm(false)}>
              취소
            </CancelButton>
            <PreviewButton 
              onClick={handlePreview}
              disabled={!newPostTitle.trim() || !newPostContent.trim() || previewLoading}
            >
              {previewLoading ? '미리보기 생성 중...' : '미리보기'}
            </PreviewButton>
            <SubmitButton 
              onClick={handleCreatePost}
              disabled={!newPostTitle.trim() || !newPostContent.trim() || submitting}
            >
              {submitting ? '작성 중...' : '작성하기'}
            </SubmitButton>
          </FormButtons>
        </CreatePostForm>
      )}

      {/* 미리보기 모달 */}
      {showPreview && (
        <PreviewModal onClick={() => setShowPreview(false)}>
          <PreviewContent onClick={(e) => e.stopPropagation()}>
            <PreviewHeader>
              <h3>게시글 미리보기</h3>
              <PreviewCloseButton onClick={() => setShowPreview(false)}>
                닫기
              </PreviewCloseButton>
            </PreviewHeader>
            <PreviewBody>
              <div dangerouslySetInnerHTML={{ __html: previewContent }} />
            </PreviewBody>
          </PreviewContent>
        </PreviewModal>
      )}

      <Controls>
        <SortButtons>
          <SortButton 
            $active={sortBy === 'latest'} 
            onClick={() => setSortBy('latest')}
          >
            최신순
          </SortButton>
          <SortButton 
            $active={sortBy === 'popular'} 
            onClick={() => setSortBy('popular')}
          >
            인기순
          </SortButton>
          <SortButton 
            $active={sortBy === 'views'} 
            onClick={() => setSortBy('views')}
          >
            조회순
          </SortButton>
        </SortButtons>
      </Controls>

      <Content>
        {loading ? (
          <EmptyState>로딩 중...</EmptyState>
        ) : discussions.length === 0 ? (
          <EmptyState>
            아직 게시글이 없습니다.<br />
            첫 번째 게시글을 작성해보세요!
          </EmptyState>
        ) : (
          <PostList>
            {discussions.map((discussion) => (
              <PostItem 
                key={discussion.id}
                onClick={() => fetchDiscussionDetail(discussion.id)}
              >
                <PostTitle>{discussion.title}</PostTitle>
                <PostMeta>
                  <PostInfo>
                    <span>{discussion.user.username}</span>
                    <span>{formatDate(discussion.created_at)}</span>
                  </PostInfo>
                  <PostStats>
                    <StatItem>
                      <Eye size={14} />
                      {discussion.views}
                    </StatItem>
                    <StatItem>
                      <ThumbsUp size={14} />
                      {discussion.likes_count}
                    </StatItem>
                    <StatItem>
                      <MessageSquare size={14} />
                      {discussion.comments_count}
                    </StatItem>
                  </PostStats>
                </PostMeta>
              </PostItem>
            ))}
          </PostList>
        )}
      </Content>
    </Container>
  );
};

export default DiscussionBoard; 