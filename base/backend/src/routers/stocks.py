from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import desc, and_
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime, timedelta
from database import get_db
from models import Stock, StockPrice, VolumeDetail, User
from routers.auth import get_current_user

router = APIRouter(dependencies=[Depends(get_current_user)])

class StockResponse(BaseModel):
    id: int
    code: str
    name: str
    market: str
    sector: Optional[str]
    current_price: float
    previous_close: float
    change_amount: float
    change_percent: float
    market_cap: Optional[int]

class StockPriceResponse(BaseModel):
    timestamp: datetime
    open_price: float
    high_price: float
    low_price: float
    close_price: float
    volume: int

class CandlestickData(BaseModel):
    timestamp: str
    open: float
    high: float
    low: float
    close: float
    volume: int

class VolumeDetailResponse(BaseModel):
    timestamp: datetime
    individual_volume: int
    foreign_volume: int
    institutional_volume: int
    total_volume: int

class MarketSummaryResponse(BaseModel):
    total_stocks: int
    rising_stocks: int
    falling_stocks: int
    unchanged_stocks: int

@router.get("/", response_model=List[StockResponse])
async def get_stocks(
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    query = db.query(Stock)
    
    if search:
        query = query.filter(
            (Stock.name.contains(search)) | 
            (Stock.code.contains(search))
        )
    
    stocks = query.offset(skip).limit(limit).all()
    
    result = []
    for stock in stocks:
        change_amount = float(stock.current_price - stock.previous_close)
        change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
        
        result.append(StockResponse(
            id=stock.id,
            code=stock.code,
            name=stock.name,
            market=stock.market,
            sector=stock.sector,
            current_price=float(stock.current_price),
            previous_close=float(stock.previous_close),
            change_amount=change_amount,
            change_percent=change_percent,
            market_cap=stock.market_cap
        ))
    
    return result

@router.get("/stock", response_model=StockResponse)
async def get_stock_by_code(
    id: str = Query(..., description="종목 코드 (예: 005930)"),
    db: Session = Depends(get_db)
):
    stock = db.query(Stock).filter(Stock.code == id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    change_amount = float(stock.current_price - stock.previous_close)
    change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
    
    return StockResponse(
        id=stock.id,
        code=stock.code,
        name=stock.name,
        market=stock.market,
        sector=stock.sector,
        current_price=float(stock.current_price),
        previous_close=float(stock.previous_close),
        change_amount=change_amount,
        change_percent=change_percent,
        market_cap=stock.market_cap
    )

@router.get("/stock/candlestick", response_model=List[CandlestickData])
async def get_candlestick_by_code(
    id: str = Query(..., description="종목 코드 (예: 005930)"),
    hours: int = Query(default=24, description="조회할 시간 (시간 단위)"),
    db: Session = Depends(get_db)
):
    stock = db.query(Stock).filter(Stock.code == id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    start_time = datetime.now() - timedelta(hours=hours)
    
    prices = db.query(StockPrice).filter(
        and_(
            StockPrice.stock_id == stock.id,
            StockPrice.timestamp >= start_time
        )
    ).order_by(StockPrice.timestamp.desc()).limit(200).all()[::-1]
    
    return [
        CandlestickData(
            timestamp=price.timestamp.isoformat(),
            open=float(price.open_price),
            high=float(price.high_price),
            low=float(price.low_price),
            close=float(price.close_price),
            volume=price.volume
        )
        for price in prices
    ]

@router.get("/{stock_id}", response_model=StockResponse)
async def get_stock(stock_id: int, db: Session = Depends(get_db)):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    change_amount = float(stock.current_price - stock.previous_close)
    change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
    
    return StockResponse(
        id=stock.id,
        code=stock.code,
        name=stock.name,
        market=stock.market,
        sector=stock.sector,
        current_price=float(stock.current_price),
        previous_close=float(stock.previous_close),
        change_amount=change_amount,
        change_percent=change_percent,
        market_cap=stock.market_cap
    )

@router.get("/{stock_id}/prices", response_model=List[StockPriceResponse])
async def get_stock_prices(
    stock_id: int,
    hours: int = Query(default=1, description="조회할 시간 (시간 단위)"),
    db: Session = Depends(get_db)
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    start_time = datetime.now() - timedelta(hours=hours)
    
    prices = db.query(StockPrice).filter(
        and_(
            StockPrice.stock_id == stock_id,
            StockPrice.timestamp >= start_time
        )
    ).order_by(StockPrice.timestamp).all()
    
    return [
        StockPriceResponse(
            timestamp=price.timestamp,
            open_price=float(price.open_price),
            high_price=float(price.high_price),
            low_price=float(price.low_price),
            close_price=float(price.close_price),
            volume=price.volume
        )
        for price in prices
    ]

@router.get("/{stock_id}/candlestick", response_model=List[CandlestickData])
async def get_candlestick_data(
    stock_id: int,
    hours: int = Query(default=24, description="조회할 시간 (시간 단위)"),
    db: Session = Depends(get_db)
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    start_time = datetime.now() - timedelta(hours=hours)
    
    prices = db.query(StockPrice).filter(
        and_(
            StockPrice.stock_id == stock_id,
            StockPrice.timestamp >= start_time
        )
    ).order_by(StockPrice.timestamp.desc()).limit(200).all()[::-1]
    
    return [
        CandlestickData(
            timestamp=price.timestamp.isoformat(),
            open=float(price.open_price),
            high=float(price.high_price),
            low=float(price.low_price),
            close=float(price.close_price),
            volume=price.volume
        )
        for price in prices
    ]

@router.get("/{stock_id}/volume", response_model=List[VolumeDetailResponse])
async def get_stock_volume(
    stock_id: int,
    hours: int = Query(default=1, description="조회할 시간 (시간 단위)"),
    db: Session = Depends(get_db)
):
    stock = db.query(Stock).filter(Stock.id == stock_id).first()
    if not stock:
        raise HTTPException(status_code=404, detail="주식을 찾을 수 없습니다")
    
    start_time = datetime.now() - timedelta(hours=hours)
    
    volumes = db.query(VolumeDetail).filter(
        and_(
            VolumeDetail.stock_id == stock_id,
            VolumeDetail.timestamp >= start_time
        )
    ).order_by(VolumeDetail.timestamp).all()
    
    return [
        VolumeDetailResponse(
            timestamp=volume.timestamp,
            individual_volume=volume.individual_volume,
            foreign_volume=volume.foreign_volume,
            institutional_volume=volume.institutional_volume,
            total_volume=volume.total_volume
        )
        for volume in volumes
    ]

@router.get("/market/summary", response_model=MarketSummaryResponse)
async def get_market_summary(db: Session = Depends(get_db)):
    stocks = db.query(Stock).all()
    
    total_stocks = len(stocks)
    rising_stocks = 0
    falling_stocks = 0
    unchanged_stocks = 0
    
    for stock in stocks:
        change = float(stock.current_price - stock.previous_close)
        if change > 0:
            rising_stocks += 1
        elif change < 0:
            falling_stocks += 1
        else:
            unchanged_stocks += 1
    
    return MarketSummaryResponse(
        total_stocks=total_stocks,
        rising_stocks=rising_stocks,
        falling_stocks=falling_stocks,
        unchanged_stocks=unchanged_stocks
    )

@router.get("/market/top-movers", response_model=List[StockResponse])
async def get_top_movers(
    type: str = Query(default="gainers", description="gainers 또는 losers"),
    limit: int = Query(default=10, description="조회할 종목 수"),
    db: Session = Depends(get_db)
):
    stocks = db.query(Stock).all()
    
    stock_data = []
    for stock in stocks:
        change_amount = float(stock.current_price - stock.previous_close)
        change_percent = (change_amount / float(stock.previous_close)) * 100 if stock.previous_close > 0 else 0
        
        stock_data.append({
            'stock': stock,
            'change_percent': change_percent,
            'change_amount': change_amount
        })
    
    if type == "gainers":
        stock_data.sort(key=lambda x: x['change_percent'], reverse=True)
    else:
        stock_data.sort(key=lambda x: x['change_percent'])
    
    result = []
    for item in stock_data[:limit]:
        stock = item['stock']
        result.append(StockResponse(
            id=stock.id,
            code=stock.code,
            name=stock.name,
            market=stock.market,
            sector=stock.sector,
            current_price=float(stock.current_price),
            previous_close=float(stock.previous_close),
            change_amount=item['change_amount'],
            change_percent=item['change_percent'],
            market_cap=stock.market_cap
        ))
    
    return result
