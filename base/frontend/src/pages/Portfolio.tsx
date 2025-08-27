import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';
import { TrendingUp, TrendingDown, DollarSign, PieChart } from 'lucide-react';
import { portfolioApi } from '../services/api';

const Container = styled.div`
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

const SummaryGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
`;

const SummaryCard = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #3498db;
`;

const SummaryTitle = styled.h3`
  font-size: 14px;
  color: #7f8c8d;
  margin-bottom: 10px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
`;

const SummaryValue = styled.div<{ $color?: string }>`
  font-size: 24px;
  font-weight: 700;
  color: ${(props: any) => props.$color || '#2c3e50'};
`;

const HoldingsContainer = styled.div`
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
`;

const HoldingsHeader = styled.div`
  padding: 20px;
  border-bottom: 1px solid #ecf0f1;
`;

const HoldingsTitle = styled.h2`
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
`;

const HoldingsList = styled.div`
  padding: 0;
`;

const HoldingItem = styled.div`
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr 1fr 1fr;
  gap: 20px;
  padding: 20px;
  border-bottom: 1px solid #f8f9fa;
  align-items: center;
  cursor: pointer;
  transition: background-color 0.2s ease;
  
  &:last-child {
    border-bottom: none;
  }
  
  &:hover {
    background-color: #f8f9fa;
  }
`;

const StockInfo = styled.div``;

const StockName = styled.div`
  font-size: 16px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 4px;
`;

const StockCode = styled.div`
  font-size: 14px;
  color: #7f8c8d;
`;

const HoldingValue = styled.div`
  text-align: right;
`;

const ValueLabel = styled.div`
  font-size: 12px;
  color: #7f8c8d;
  margin-bottom: 4px;
`;

const ValueAmount = styled.div<{ $color?: string }>`
  font-size: 16px;
  font-weight: 600;
  color: ${(props: any) => props.$color || '#2c3e50'};
`;

const ProfitLoss = styled.div<{ $isPositive: boolean }>`
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
  color: ${(props: any) => props.$isPositive ? '#2ecc71' : '#e74c3c'};
`;

const EmptyState = styled.div`
  text-align: center;
  padding: 60px 20px;
  color: #7f8c8d;
`;

const EmptyIcon = styled.div`
  font-size: 48px;
  margin-bottom: 16px;
`;

const EmptyText = styled.div`
  font-size: 18px;
  margin-bottom: 8px;
`;

const EmptySubtext = styled.div`
  font-size: 14px;
`;

function Portfolio() {
  const [portfolio, setPortfolio] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    fetchPortfolio();
    
    const interval = setInterval(() => {
      fetchPortfolio();
    }, 30000);
    
    return () => clearInterval(interval);
  }, []);

  const fetchPortfolio = async () => {
    try {
      const response = await portfolioApi.getPortfolio();
      setPortfolio(response.data);
    } catch (error) {
      console.error('포트폴리오 로딩 오류:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleStockClick = (stockCode: string) => {
    navigate(`/stock/${stockCode}`);
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('ko-KR').format(amount) + '원';
  };

  const formatPercent = (percent: number) => {
    return `${percent >= 0 ? '+' : ''}${percent.toFixed(2)}%`;
  };

  if (loading) {
    return (
      <Container>
        <div>로딩 중...</div>
      </Container>
    );
  }

  if (!portfolio || portfolio.holdings.length === 0) {
    return (
      <Container>
        <Header>
          <Title>포트폴리오</Title>
          <Subtitle>보유 주식과 수익률 정보를 확인하세요</Subtitle>
        </Header>
        
        <HoldingsContainer>
          <EmptyState>
            <EmptyIcon>📊</EmptyIcon>
            <EmptyText>보유 중인 주식이 없습니다</EmptyText>
            <EmptySubtext>주식을 매수하여 포트폴리오를 시작해보세요</EmptySubtext>
          </EmptyState>
        </HoldingsContainer>
      </Container>
    );
  }

  return (
    <Container>
      <Header>
        <Title>포트폴리오</Title>
        <Subtitle>보유 주식과 수익률 정보를 확인하세요</Subtitle>
      </Header>

      <SummaryGrid>
        <SummaryCard>
          <SummaryTitle>총 자산</SummaryTitle>
          <SummaryValue>{formatCurrency(portfolio.total_assets)}</SummaryValue>
        </SummaryCard>
        <SummaryCard>
          <SummaryTitle>보유 주식 가치</SummaryTitle>
          <SummaryValue>{formatCurrency(portfolio.total_value)}</SummaryValue>
        </SummaryCard>
        <SummaryCard>
          <SummaryTitle>현금</SummaryTitle>
          <SummaryValue>{formatCurrency(portfolio.cash)}</SummaryValue>
        </SummaryCard>
        <SummaryCard>
          <SummaryTitle>총 손익</SummaryTitle>
          <SummaryValue $color={portfolio.total_profit_loss >= 0 ? '#2ecc71' : '#e74c3c'}>
            {portfolio.total_profit_loss >= 0 ? '+' : ''}{formatCurrency(portfolio.total_profit_loss)}
          </SummaryValue>
        </SummaryCard>
      </SummaryGrid>

      <HoldingsContainer>
        <HoldingsHeader>
          <HoldingsTitle>보유 종목</HoldingsTitle>
        </HoldingsHeader>
        
        <HoldingsList>
          {portfolio.holdings.map((holding: any) => (
            <HoldingItem key={holding.id} onClick={() => handleStockClick(holding.stock_code)}>
              <StockInfo>
                <StockName>{holding.stock_name}</StockName>
                <StockCode>{holding.stock_code}</StockCode>
              </StockInfo>
              
              <HoldingValue>
                <ValueLabel>보유 수량</ValueLabel>
                <ValueAmount>{holding.quantity.toLocaleString()}주</ValueAmount>
              </HoldingValue>
              
              <HoldingValue>
                <ValueLabel>평균 단가</ValueLabel>
                <ValueAmount>{formatCurrency(holding.average_price)}</ValueAmount>
              </HoldingValue>
              
              <HoldingValue>
                <ValueLabel>현재 가격</ValueLabel>
                <ValueAmount>{formatCurrency(holding.current_price)}</ValueAmount>
              </HoldingValue>
              
              <HoldingValue>
                <ValueLabel>평가 금액</ValueLabel>
                <ValueAmount>{formatCurrency(holding.total_value)}</ValueAmount>
              </HoldingValue>
              
              <HoldingValue>
                <ValueLabel>손익</ValueLabel>
                <ProfitLoss $isPositive={holding.profit_loss >= 0}>
                  {holding.profit_loss >= 0 ? <TrendingUp size={16} /> : <TrendingDown size={16} />}
                  <div>
                    <ValueAmount $color={holding.profit_loss >= 0 ? '#2ecc71' : '#e74c3c'}>
                      {holding.profit_loss >= 0 ? '+' : ''}{formatCurrency(holding.profit_loss)}
                    </ValueAmount>
                    <ValueAmount $color={holding.profit_loss >= 0 ? '#2ecc71' : '#e74c3c'}>
                      {formatPercent(holding.profit_loss_percent)}
                    </ValueAmount>
                  </div>
                </ProfitLoss>
              </HoldingValue>
            </HoldingItem>
          ))}
        </HoldingsList>
      </HoldingsContainer>
    </Container>
  );
}

export default Portfolio; 