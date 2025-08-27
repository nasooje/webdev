from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import List

from database import get_db
from models import Watchlist, Stock, User
from routers.auth import get_current_user

router = APIRouter()

class WatchlistAdd(BaseModel):
    stock_id: int

class WatchlistResponse(BaseModel):
    id: int
    stock_id: int
    stock_code: str
    stock_name: str
    current_price: float
    previous_close: float
    change_amount: float
    change_percent: float
    market: str
    sector: str

@router.get("/", response_model=List[WatchlistResponse])
async def get_watchlist(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    watchlists = db.query(Watchlist).filter(Watchlist.user_id == current_user.id).all()
    
    result = []
    for watchlist in watchlists:
        stock = db.query(Stock).filter(Stock.id == watchlist.stock_id).first()
        if stock:
            change_amount = float(stock.current_price - stock.previous_close)
            change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
            
            result.append(WatchlistResponse(
                id=watchlist.id,
                stock_id=stock.id,
                stock_code=stock.code,
                stock_name=stock.name,
                current_price=float(stock.current_price),
                previous_close=float(stock.previous_close),
                change_amount=change_amount,
                change_percent=change_percent,
                market=stock.market,
                sector=stock.sector or ""
            ))
    
    return result

@router.post("/", response_model=WatchlistResponse)
async def add_to_watchlist(
    watchlist_add: WatchlistAdd,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    stock = db.query(Stock).filter(Stock.id == watchlist_add.stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    existing = db.query(Watchlist).filter(
        Watchlist.user_id == current_user.id,
        Watchlist.stock_id == watchlist_add.stock_id
    ).first()
    
    if existing:
        raise HTTPException(status_code=400, detail="이미 관심종목에 추가된 주식입니다")
    
    watchlist = Watchlist(
        user_id=current_user.id,
        stock_id=watchlist_add.stock_id
    )
    
    db.add(watchlist)
    db.commit()
    db.refresh(watchlist)
    
    change_amount = float(stock.current_price - stock.previous_close)
    change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
    
    return WatchlistResponse(
        id=watchlist.id,
        stock_id=stock.id,
        stock_code=stock.code,
        stock_name=stock.name,
        current_price=float(stock.current_price),
        previous_close=float(stock.previous_close),
        change_amount=change_amount,
        change_percent=change_percent,
        market=stock.market,
        sector=stock.sector or ""
    )

@router.delete("/{stock_id}")
async def remove_from_watchlist(
    stock_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    watchlist = db.query(Watchlist).filter(
        Watchlist.user_id == current_user.id,
        Watchlist.stock_id == stock_id
    ).first()
    
    if not watchlist:
        raise HTTPException(status_code=404, detail="관심종목에서 해당 주식을 찾을 수 없습니다")
    
    db.delete(watchlist)
    db.commit()
    
    return {"message": "관심종목에서 제거되었습니다"}

@router.get("/check/{stock_id}")
async def check_in_watchlist(
    stock_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    watchlist = db.query(Watchlist).filter(
        Watchlist.user_id == current_user.id,
        Watchlist.stock_id == stock_id
    ).first()
    
    return {"in_watchlist": watchlist is not None}

@router.get("/user/{user_id}", response_model=List[WatchlistResponse])
async def get_user_watchlist(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if current_user.id != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, 
            detail="다른 사용자의 관심종목에 접근할 수 없습니다"
        )
    
    watchlists = db.query(Watchlist).filter(Watchlist.user_id == user_id).all()
    
    if not watchlists:
        raise HTTPException(status_code=404, detail="해당 사용자의 관심종목을 찾을 수 없습니다")
    
    result = []
    for watchlist in watchlists:
        stock = db.query(Stock).filter(Stock.id == watchlist.stock_id).first()
        if stock:
            change_amount = float(stock.current_price - stock.previous_close)
            change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
            
            result.append(WatchlistResponse(
                id=watchlist.id,
                stock_id=stock.id,
                stock_code=stock.code,
                stock_name=stock.name,
                current_price=float(stock.current_price),
                previous_close=float(stock.previous_close),
                change_amount=change_amount,
                change_percent=change_percent,
                market=stock.market,
                sector=stock.sector or ""
            ))
    
    return result

@router.get("/item/{watchlist_id}", response_model=WatchlistResponse)
async def get_watchlist_item(
    watchlist_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    watchlist = db.query(Watchlist).filter(Watchlist.id == watchlist_id).first()
    
    if not watchlist:
        raise HTTPException(status_code=404, detail="관심종목을 찾을 수 없습니다")
    
    if watchlist.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, 
            detail="다른 사용자의 관심종목에 접근할 수 없습니다"
        )
    
    stock = db.query(Stock).filter(Stock.id == watchlist.stock_id).first()
    user = db.query(User).filter(User.id == watchlist.user_id).first()
    
    if not stock or not user:
        raise HTTPException(status_code=404, detail="관련 정보를 찾을 수 없습니다")
    
    change_amount = float(stock.current_price - stock.previous_close)
    change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
    
    return WatchlistResponse(
        id=watchlist.id,
        stock_id=stock.id,
        stock_code=stock.code,
        stock_name=stock.name,
        current_price=float(stock.current_price),
        previous_close=float(stock.previous_close),
        change_amount=change_amount,
        change_percent=change_percent,
        market=stock.market,
        sector=stock.sector or ""
    ) 