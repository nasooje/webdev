from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import and_
from typing import List, Optional
from database import get_db
from models import FinancialStatement, Stock, User
from routers.auth import get_current_user
import logging

logger = logging.getLogger(__name__)

router = APIRouter(dependencies=[Depends(get_current_user)])

@router.get("/stock/{stock_code}")
async def get_financial_statements(
    stock_code: str,
    year: Optional[int] = Query(None, description="특정 연도 조회"),
    quarter: Optional[int] = Query(None, description="특정 분기 조회 (1-4)"),
    db: Session = Depends(get_db)
):
    try:
        stock = db.query(Stock).filter(Stock.code == stock_code).first()
        if not stock:
            raise HTTPException(status_code=404, detail="주식 종목을 찾을 수 없습니다.")
        
        query = db.query(FinancialStatement).filter(FinancialStatement.stock_id == stock.id)
        
        if year:
            query = query.filter(FinancialStatement.year == year)
        if quarter:
            query = query.filter(FinancialStatement.quarter == quarter)
        
        statements = query.order_by(
            FinancialStatement.year.desc(),
            FinancialStatement.quarter.desc()
        ).all()
        
        return {
            "stock_code": stock_code,
            "stock_name": stock.name,
            "financial_statements": statements
        }
        
    except Exception as e:
        logger.error(f"재무제표 조회 오류: {e}")
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.get("/stock/{stock_code}/latest")
async def get_latest_financial_statement(
    stock_code: str,
    db: Session = Depends(get_db)
):
    try:
        stock = db.query(Stock).filter(Stock.code == stock_code).first()
        if not stock:
            raise HTTPException(status_code=404, detail="주식 종목을 찾을 수 없습니다.")
        
        latest_statement = db.query(FinancialStatement).filter(
            FinancialStatement.stock_id == stock.id
        ).order_by(
            FinancialStatement.year.desc(),
            FinancialStatement.quarter.desc()
        ).first()
        
        if not latest_statement:
            raise HTTPException(status_code=404, detail="재무제표 데이터를 찾을 수 없습니다.")
        
        return {
            "stock_code": stock_code,
            "stock_name": stock.name,
            "latest_statement": latest_statement
        }
        
    except Exception as e:
        logger.error(f"최신 재무제표 조회 오류: {e}")
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.get("/stock/{stock_code}/yearly")
async def get_yearly_financial_summary(
    stock_code: str,
    db: Session = Depends(get_db)
):
    try:
        stock = db.query(Stock).filter(Stock.code == stock_code).first()
        if not stock:
            raise HTTPException(status_code=404, detail="주식 종목을 찾을 수 없습니다.")
        
        yearly_statements = db.query(FinancialStatement).filter(
            and_(
                FinancialStatement.stock_id == stock.id,
                FinancialStatement.quarter == 4
            )
        ).order_by(FinancialStatement.year.desc()).all()
        
        return {
            "stock_code": stock_code,
            "stock_name": stock.name,
            "yearly_summary": yearly_statements
        }
        
    except Exception as e:
        logger.error(f"연도별 재무 요약 조회 오류: {e}")
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.")

@router.get("/comparison")
async def compare_financial_statements(
    stock_codes: List[str] = Query(..., description="비교할 주식 종목 코드들"),
    year: int = Query(..., description="비교할 연도"),
    quarter: int = Query(..., description="비교할 분기"),
    db: Session = Depends(get_db)
):
    try:
        comparison_data = []
        
        for stock_code in stock_codes:
            stock = db.query(Stock).filter(Stock.code == stock_code).first()
            if not stock:
                continue
            
            statement = db.query(FinancialStatement).filter(
                and_(
                    FinancialStatement.stock_id == stock.id,
                    FinancialStatement.year == year,
                    FinancialStatement.quarter == quarter
                )
            ).first()
            
            if statement:
                comparison_data.append({
                    "stock_code": stock_code,
                    "stock_name": stock.name,
                    "financial_data": statement
                })
        
        return {
            "period": f"{year}년 {quarter}분기",
            "comparison": comparison_data
        }
        
    except Exception as e:
        logger.error(f"재무제표 비교 오류: {e}")
        raise HTTPException(status_code=500, detail="서버 오류가 발생했습니다.") 