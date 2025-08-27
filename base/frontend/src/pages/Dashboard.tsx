import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';
import { TrendingUp, TrendingDown } from 'lucide-react';
import { stocksApi } from '../services/api';

const DashboardContainer = styled.div`
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
`;

const Header = styled.div`
  margin-bottom: 30px;
`;

const Title = styled.h1`
  font-size: 28px;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 10px;
`;

const Subtitle = styled.p`
  color: #7f8c8d;
  font-size: 16px;
`;

const StatsGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
`;

const StatCard = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #3498db;
`;

const StatTitle = styled.h3`
  font-size: 14px;
  color: #7f8c8d;
  margin-bottom: 10px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
`;

const StatValue = styled.div`
  font-size: 24px;
  font-weight: 700;
  color: #2c3e50;
`;

const StockGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
`;

const StockCard = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }
`;

const StockHeader = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 15px;
`;

const StockInfo = styled.div`
  flex: 1;
`;

const StockName = styled.h3`
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 5px;
`;

const StockCode = styled.span`
  font-size: 14px;
  color: #7f8c8d;
  background-color: #ecf0f1;
  padding: 2px 8px;
  border-radius: 4px;
`;

const StockPrice = styled.div`
  text-align: right;
`;

const CurrentPrice = styled.div`
  font-size: 20px;
  font-weight: 700;
  color: #2c3e50;
`;

const PriceChange = styled.div<{ $isPositive: boolean }>`
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
  font-size: 14px;
  font-weight: 600;
  color: ${(props: any) => props.$isPositive ? '#2ecc71' : '#e74c3c'};
  margin-top: 5px;
`;

const StockDetails = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #ecf0f1;
`;

const Market = styled.span`
  font-size: 12px;
  color: #7f8c8d;
  background-color: #f8f9fa;
  padding: 4px 8px;
  border-radius: 4px;
`;

const Sector = styled.span`
  font-size: 12px;
  color: #3498db;
  font-weight: 500;
`;

function Dashboard() {
  const navigate = useNavigate();
  const [stocks, setStocks] = useState<any[]>([]);
  const [marketSummary, setMarketSummary] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
    
    const interval = setInterval(() => {
      fetchData();
    }, 30000);
    
    return () => clearInterval(interval);
  }, []);

  const fetchData = async () => {
    try {
      const [stocksResponse, summaryResponse] = await Promise.all([
        stocksApi.getStocks(),
        stocksApi.getMarketSummary()
      ]);
      
      setStocks(stocksResponse.data);
      setMarketSummary(summaryResponse.data);
    } catch (error) {
      console.error('데이터 로딩 오류:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleStockClick = (stockCode: string) => {
    navigate(`/stock/${stockCode}`);
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('ko-KR').format(amount);
  };

  const formatPercent = (percent: number) => {
    return `${percent >= 0 ? '+' : ''}${percent.toFixed(2)}%`;
  };

  if (loading) {
    return (
      <DashboardContainer>
        <div>로딩 중...</div>
      </DashboardContainer>
    );
  }

  return (
    <DashboardContainer>
      <Header>
        <Title>시장 현황</Title>
        <Subtitle>실시간 주식 정보를 확인하세요</Subtitle>
      </Header>

      {marketSummary && (
        <StatsGrid>
          <StatCard>
            <StatTitle>전체 종목</StatTitle>
            <StatValue>{marketSummary.total_stocks}개</StatValue>
          </StatCard>
          <StatCard>
            <StatTitle>상승 종목</StatTitle>
            <StatValue style={{ color: '#2ecc71' }}>{marketSummary.rising_stocks}개</StatValue>
          </StatCard>
          <StatCard>
            <StatTitle>하락 종목</StatTitle>
            <StatValue style={{ color: '#e74c3c' }}>{marketSummary.falling_stocks}개</StatValue>
          </StatCard>
          <StatCard>
            <StatTitle>보합 종목</StatTitle>
            <StatValue>{marketSummary.unchanged_stocks}개</StatValue>
          </StatCard>
        </StatsGrid>
      )}

      <StockGrid>
        {stocks.map((stock: any) => (
          <StockCard key={stock.id} onClick={() => handleStockClick(stock.code)}>
            <StockHeader>
              <StockInfo>
                <StockName>{stock.name}</StockName>
                <StockCode>{stock.code}</StockCode>
              </StockInfo>
              <StockPrice>
                <CurrentPrice>{formatCurrency(stock.current_price)}</CurrentPrice>
                <PriceChange $isPositive={stock.change_percent >= 0}>
                  {stock.change_percent >= 0 ? <TrendingUp size={16} /> : <TrendingDown size={16} />}
                  {formatPercent(stock.change_percent)}
                </PriceChange>
              </StockPrice>
            </StockHeader>
            <StockDetails>
              <Market>{stock.market}</Market>
              <Sector>{stock.sector || '기타'}</Sector>
            </StockDetails>
          </StockCard>
        ))}
      </StockGrid>
    </DashboardContainer>
  );
}

export default Dashboard; 