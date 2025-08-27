from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
from decimal import Decimal

from database import get_db
from models import Order, Stock, User, Portfolio, Transaction, OrderType, PriceType, OrderStatus, TransactionType
from routers.auth import get_current_user

router = APIRouter()

class OrderCreate(BaseModel):
    stock_id: int
    order_type: str  
    price_type: str
    quantity: int
    price: Optional[float] = None

class OrderResponse(BaseModel):
    id: int
    stock_id: int
    stock_code: str
    stock_name: str
    order_type: str
    price_type: str
    quantity: int
    price: Optional[float]
    status: str
    created_at: datetime
    executed_at: Optional[datetime]

@router.post("/", response_model=OrderResponse)
async def create_order(
    order: OrderCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    stock = db.query(Stock).filter(Stock.id == order.stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    if order.order_type not in ["buy", "sell"]:
        raise HTTPException(status_code=400, detail="올바르지 않은 주문 타입입니다")
    
    if order.price_type not in ["market", "limit"]:
        raise HTTPException(status_code=400, detail="올바르지 않은 가격 타입입니다")
    
    if order.price_type == "limit" and order.price is None:
        raise HTTPException(status_code=400, detail="지정가 주문은 가격을 입력해야 합니다")

    if order.quantity <= 0:
        raise HTTPException(status_code=400, detail="수량은 1 이상이어야 합니다")
    if order.price_type == "limit" and order.price is not None and order.price <= 0:
        raise HTTPException(status_code=400, detail="가격은 0보다 커야 합니다")
    
    execution_price = order.price if order.price_type == "limit" else float(stock.current_price)

    if execution_price <= 0:
        raise HTTPException(status_code=400, detail="실행 가격이 0보다 커야 합니다")
    
    if order.order_type == "buy":
        required_cash = execution_price * order.quantity
        if float(current_user.cash) < required_cash:
            raise HTTPException(status_code=400, detail="잔액이 부족합니다")
    
    elif order.order_type == "sell":
        portfolio = db.query(Portfolio).filter(
            Portfolio.user_id == current_user.id,
            Portfolio.stock_id == order.stock_id
        ).first()
        
        if not portfolio or portfolio.quantity < order.quantity:
            raise HTTPException(status_code=400, detail="보유 주식이 부족합니다")
    
    db_order = Order(
        user_id=current_user.id,
        stock_id=order.stock_id,
        order_type=OrderType(order.order_type),
        price_type=PriceType(order.price_type),
        quantity=order.quantity,
        price=Decimal(str(execution_price)) if execution_price else None,
        status=OrderStatus.pending
    )
    
    db.add(db_order)
    db.commit()
    db.refresh(db_order)
    
    if order.price_type == "market":
        execute_order(db_order.id, db)
    
    return OrderResponse(
        id=db_order.id,
        stock_id=stock.id,
        stock_code=stock.code,
        stock_name=stock.name,
        order_type=db_order.order_type.value,
        price_type=db_order.price_type.value,
        quantity=db_order.quantity,
        price=float(db_order.price) if db_order.price else None,
        status=db_order.status.value,
        created_at=db_order.created_at,
        executed_at=db_order.executed_at
    )

def execute_order(order_id: int, db: Session):
    order = db.query(Order).filter(Order.id == order_id).first()
    if not order or order.status != OrderStatus.pending:
        return
    
    user = db.query(User).filter(User.id == order.user_id).first()
    stock = db.query(Stock).filter(Stock.id == order.stock_id).first()
    
    if not user or not stock:
        return
    
    execution_price = float(order.price) if order.price else float(stock.current_price)
    total_amount = execution_price * order.quantity
    
    if order.order_type == OrderType.buy:
        if float(user.cash) < total_amount:
            order.status = OrderStatus.cancelled
            db.commit()
            return
        
        user.cash = Decimal(str(float(user.cash) - total_amount))
        
        portfolio = db.query(Portfolio).filter(
            Portfolio.user_id == user.id,
            Portfolio.stock_id == stock.id
        ).first()
        
        if portfolio:
            total_quantity = portfolio.quantity + order.quantity
            total_value = (float(portfolio.average_price) * portfolio.quantity) + total_amount
            new_average_price = total_value / total_quantity
            
            portfolio.quantity = total_quantity
            portfolio.average_price = Decimal(str(new_average_price))
        else:
            portfolio = Portfolio(
                user_id=user.id,
                stock_id=stock.id,
                quantity=order.quantity,
                average_price=Decimal(str(execution_price))
            )
            db.add(portfolio)
    
    elif order.order_type == OrderType.sell:
        portfolio = db.query(Portfolio).filter(
            Portfolio.user_id == user.id,
            Portfolio.stock_id == stock.id
        ).first()
        
        if not portfolio or portfolio.quantity < order.quantity:
            order.status = OrderStatus.cancelled
            db.commit()
            return
        
        user.cash = Decimal(str(float(user.cash) + total_amount))
        
        portfolio.quantity -= order.quantity
        if portfolio.quantity == 0:
            db.delete(portfolio)
    
    transaction = Transaction(
        user_id=user.id,
        stock_id=stock.id,
        transaction_type=TransactionType(order.order_type.value),
        quantity=order.quantity,
        price=Decimal(str(execution_price)),
        total_amount=Decimal(str(total_amount))
    )
    db.add(transaction)
    
    order.status = OrderStatus.completed
    order.executed_at = datetime.now()
    
    db.commit()

@router.get("/", response_model=List[OrderResponse])
async def get_orders(
    status: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    query = db.query(Order).filter(Order.user_id == current_user.id)
    
    if status:
        query = query.filter(Order.status == OrderStatus(status))
    
    orders = query.order_by(Order.created_at.desc()).all()
    
    result = []
    for order in orders:
        stock = db.query(Stock).filter(Stock.id == order.stock_id).first()
        if stock:
            result.append(OrderResponse(
                id=order.id,
                stock_id=stock.id,
                stock_code=stock.code,
                stock_name=stock.name,
                order_type=order.order_type.value,
                price_type=order.price_type.value,
                quantity=order.quantity,
                price=float(order.price) if order.price else None,
                status=order.status.value,
                created_at=order.created_at,
                executed_at=order.executed_at
            ))
    
    return result

@router.get("/{order_id}", response_model=OrderResponse)
async def get_order_by_id(
    order_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    order = db.query(Order).filter(
        Order.id == order_id,
        Order.user_id == current_user.id
    ).first()
    
    if not order:
        raise HTTPException(status_code=404, detail="주문을 찾을 수 없습니다")
    
    stock = db.query(Stock).filter(Stock.id == order.stock_id).first()
    
    if not stock:
        raise HTTPException(status_code=404, detail="관련 정보를 찾을 수 없습니다")
    
    return OrderResponse(
        id=order.id,
        stock_id=stock.id,
        stock_code=stock.code,
        stock_name=stock.name,
        order_type=order.order_type.value,
        price_type=order.price_type.value,
        quantity=order.quantity,
        price=float(order.price) if order.price else None,
        status=order.status.value,
        created_at=order.created_at,
        executed_at=order.executed_at
    )

@router.delete("/{order_id}")
async def cancel_order(
    order_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    order = db.query(Order).filter(
        Order.id == order_id,
        Order.user_id == current_user.id
    ).first()
    
    if not order:
        raise HTTPException(status_code=404, detail="주문을 찾을 수 없습니다")
    
    if order.status != OrderStatus.pending:
        raise HTTPException(status_code=400, detail="대기 중인 주문만 취소할 수 있습니다")
    
    order.status = OrderStatus.cancelled
    db.commit()
    
    return {"message": "주문이 취소되었습니다"} 