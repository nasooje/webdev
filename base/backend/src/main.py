from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import logging
import os
import time
from sqlalchemy import text
from sqlalchemy.exc import OperationalError

from database import engine, get_db
from models import Base
from routers import auth, stocks, portfolio, orders, watchlist, financial, discussions
from services.stock_simulator import start_stock_simulator, create_historical_data

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def wait_for_database(max_retries=30, retry_interval=2):
    retries = 0
    while retries < max_retries:
        try:
            logger.info(f"데이터베이스 연결 시도 중... ({retries + 1}/{max_retries})")
            
            db = next(get_db())
            db.execute(text("SELECT 1"))
            db.close()
            
            logger.info("데이터베이스 연결 성공!")
            return True
            
        except OperationalError as e:
            logger.warning(f"데이터베이스 연결 실패: {e}")
            retries += 1
            if retries < max_retries:
                logger.info(f"{retry_interval}초 후 재시도...")
                time.sleep(retry_interval)
            else:
                logger.error("데이터베이스 연결 최대 재시도 횟수 초과")
                raise
        except Exception as e:
            logger.error(f"예상치 못한 오류: {e}")
            raise
    
    return False

@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("애플리케이션이 시작되었습니다.")
    
    try:
        wait_for_database()
        
        logger.info("데이터베이스 테이블 생성 중...")
        Base.metadata.create_all(bind=engine)
        logger.info("데이터베이스 테이블 생성 완료!")
        
        from database import SessionLocal
        from models import StockPrice
        
        db = SessionLocal()
        existing_data = db.query(StockPrice).first()
        db.close()
        
        if os.getenv("SKIP_SEED", "false").lower() == "true":
            logger.info("SKIP_SEED=true; 과거 데이터 생성을 건너뜁니다.")
        elif not existing_data:
            logger.info("과거 데이터가 없습니다. 생성 중...")
            create_historical_data()
        else:
            logger.info("기존 과거 데이터가 있습니다.")
            
    except Exception as e:
        logger.error(f"초기화 오류: {e}")
        raise
    
    start_stock_simulator()
    
    yield
    
    logger.info("애플리케이션이 종료되었습니다.")

app = FastAPI(
    title="성공 증권 API",
    description="한국형 증권 거래 시스템",
    version="1.0.0",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/auth", tags=["인증"])
app.include_router(stocks.router, prefix="/api/stocks", tags=["주식"])
app.include_router(portfolio.router, prefix="/api/portfolio", tags=["포트폴리오"])
app.include_router(orders.router, prefix="/api/orders", tags=["주문"])
app.include_router(watchlist.router, prefix="/api/watchlist", tags=["관심종목"])
app.include_router(financial.router, prefix="/api/financial", tags=["재무제표"])
app.include_router(discussions.router, prefix="/api/discussions", tags=["종목토론"])

@app.get("/")
async def root():
    return {"message": "성공 증권 API 서버가 실행 중입니다."}

@app.get("/health")
async def health_check():
    try:
        db = next(get_db())
        db.execute(text("SELECT 1"))
        db.close()
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        return {"status": "unhealthy", "error": str(e)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 