from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import List

from database import get_db
from models import Portfolio, Stock, User
from routers.auth import get_current_user

router = APIRouter()

class PortfolioResponse(BaseModel):
    id: int
    stock_id: int
    stock_code: str
    stock_name: str
    quantity: int
    average_price: float
    current_price: float
    total_value: float
    profit_loss: float
    profit_loss_percent: float

class PortfolioSummaryResponse(BaseModel):
    total_value: float
    total_profit_loss: float
    total_profit_loss_percent: float
    cash: float
    total_assets: float
    holdings: List[PortfolioResponse]

@router.get("/", response_model=PortfolioSummaryResponse)
async def get_portfolio(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    portfolios = db.query(Portfolio).filter(Portfolio.user_id == current_user.id).all()
    
    holdings = []
    total_value = 0
    total_profit_loss = 0
    
    for portfolio in portfolios:
        stock = db.query(Stock).filter(Stock.id == portfolio.stock_id).first()
        if not stock:
            continue
            
        current_price = float(stock.current_price)
        average_price = float(portfolio.average_price)
        quantity = portfolio.quantity
        
        total_holding_value = current_price * quantity
        profit_loss = (current_price - average_price) * quantity
        profit_loss_percent = ((current_price - average_price) / average_price) * 100 if average_price > 0 else 0
        
        holdings.append(PortfolioResponse(
            id=portfolio.id,
            stock_id=stock.id,
            stock_code=stock.code,
            stock_name=stock.name,
            quantity=quantity,
            average_price=average_price,
            current_price=current_price,
            total_value=total_holding_value,
            profit_loss=profit_loss,
            profit_loss_percent=profit_loss_percent
        ))
        
        total_value += total_holding_value
        total_profit_loss += profit_loss
    
    cash = float(current_user.cash)
    total_assets = total_value + cash
    total_profit_loss_percent = (total_profit_loss / (total_value - total_profit_loss)) * 100 if (total_value - total_profit_loss) > 0 else 0
    
    return PortfolioSummaryResponse(
        total_value=total_value,
        total_profit_loss=total_profit_loss,
        total_profit_loss_percent=total_profit_loss_percent,
        cash=cash,
        total_assets=total_assets,
        holdings=holdings
    )

@router.get("/{stock_id}", response_model=PortfolioResponse)
async def get_portfolio_item(
    stock_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    portfolio = db.query(Portfolio).filter(
        Portfolio.user_id == current_user.id,
        Portfolio.stock_id == stock_id
    ).first()
    
    if not portfolio:
        raise HTTPException(status_code=404, detail="포트폴리오에서 해당 주식을 찾을 수 없습니다")
    
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    current_price = float(stock.current_price)
    average_price = float(portfolio.average_price)
    quantity = portfolio.quantity
    
    total_value = current_price * quantity
    profit_loss = (current_price - average_price) * quantity
    profit_loss_percent = ((current_price - average_price) / average_price) * 100 if average_price > 0 else 0
    
    return PortfolioResponse(
        id=portfolio.id,
        stock_id=stock.id,
        stock_code=stock.code,
        stock_name=stock.name,
        quantity=quantity,
        average_price=average_price,
        current_price=current_price,
        total_value=total_value,
        profit_loss=profit_loss,
        profit_loss_percent=profit_loss_percent
    ) 