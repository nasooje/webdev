import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';
import { Star, TrendingUp, TrendingDown, Trash2 } from 'lucide-react';
import { watchlistApi } from '../services/api';

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

const WatchlistContainer = styled.div`
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
`;

const WatchlistGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  padding: 20px;
`;

const StockCard = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  position: relative;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }
`;

const RemoveButton = styled.button`
  position: absolute;
  top: 10px;
  right: 10px;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s ease;
  
  &:hover {
    background: #c0392b;
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

function Watchlist() {
  const navigate = useNavigate();
  const [watchlist, setWatchlist] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchWatchlist();
    
    const interval = setInterval(() => {
      fetchWatchlist();
    }, 30000);
    
    return () => clearInterval(interval);
  }, []);

  const fetchWatchlist = async () => {
    try {
      const response = await watchlistApi.getWatchlist();
      setWatchlist(response.data);
    } catch (error) {
      console.error('관심종목 로딩 오류:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRemoveFromWatchlist = async (stockId: number, event: React.MouseEvent) => {
    event.stopPropagation();
    try {
      await watchlistApi.removeFromWatchlist(stockId);
      setWatchlist(watchlist.filter(item => item.stock_id !== stockId));
    } catch (error) {
      console.error('관심종목 제거 오류:', error);
      alert('관심종목 제거에 실패했습니다.');
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
      <Container>
        <div>로딩 중...</div>
      </Container>
    );
  }

  return (
    <Container>
      <Header>
        <Title>관심종목</Title>
        <Subtitle>관심종목 목록을 확인하고 관리하세요</Subtitle>
      </Header>

      <WatchlistContainer>
        {watchlist.length === 0 ? (
          <EmptyState>
            <EmptyIcon>⭐</EmptyIcon>
            <EmptyText>관심종목이 없습니다</EmptyText>
            <EmptySubtext>주식 상세 페이지에서 관심종목을 추가해보세요</EmptySubtext>
          </EmptyState>
        ) : (
          <WatchlistGrid>
            {watchlist.map((item: any) => (
              <StockCard key={item.id} onClick={() => handleStockClick(item.stock_code)}>
                <RemoveButton onClick={(e) => handleRemoveFromWatchlist(item.stock_id, e)}>
                  <Trash2 size={14} />
                </RemoveButton>
                
                <StockHeader>
                  <StockInfo>
                    <StockName>{item.stock_name}</StockName>
                    <StockCode>{item.stock_code}</StockCode>
                  </StockInfo>
                  <StockPrice>
                    <CurrentPrice>{formatCurrency(item.current_price)}</CurrentPrice>
                    <PriceChange $isPositive={item.change_percent >= 0}>
                      {item.change_percent >= 0 ? <TrendingUp size={16} /> : <TrendingDown size={16} />}
                      {formatPercent(item.change_percent)}
                    </PriceChange>
                  </StockPrice>
                </StockHeader>
                
                <StockDetails>
                  <Market>{item.market}</Market>
                  <Sector>{item.sector || '기타'}</Sector>
                </StockDetails>
              </StockCard>
            ))}
          </WatchlistGrid>
        )}
      </WatchlistContainer>
    </Container>
  );
}

export default Watchlist; 