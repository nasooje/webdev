import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import styled from 'styled-components';
import { TrendingUp, TrendingDown, Star, StarOff, ShoppingCart, DollarSign, BarChart3, TrendingDownIcon } from 'lucide-react';
import { api, ordersApi, financialApi } from '../services/api';
import CandlestickChart from '../components/CandlestickChart';
import FinancialStatements from '../components/FinancialStatements';
import DiscussionBoard from '../components/DiscussionBoard';

const Container = styled.div`
  padding: 20px;
  max-width: 1800px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
`;

const HeaderSection = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 40px;
`;

const MiddleSection = styled.div`
  display: grid;
  grid-template-columns: 3fr 300px;
  gap: 20px;
  
  @media (max-width: 1200px) {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  /* 차트 영역이 충분히 넓어지도록 조정 */
  min-width: 0;
  overflow: visible;
`;

const TabSection = styled.div`
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
`;

const TabButtons = styled.div`
  display: flex;
  border-bottom: 1px solid #eee;
`;

const TabButton = styled.button<{ $active: boolean }>`
  flex: 1;
  background: ${props => props.$active ? '#667eea' : 'white'};
  color: ${props => props.$active ? 'white' : '#666'};
  border: none;
  padding: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  
  &:hover {
    background: ${props => props.$active ? '#5a6fd8' : '#f8f9fa'};
  }
`;

const TabContent = styled.div`
  padding: 20px;
`;

const ChartSection = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: visible;
  min-width: 0;
  height: fit-content;
`;

const OrderSection = styled.div`
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  height: fit-content;
`;

const BottomSection = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
`;

const ContentSections = styled.div`
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-top: 20px;
`;

const FinancialSection = styled.div`
  background: white;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  min-height: 600px;
`;

const DiscussionSection = styled.div`
  background: white;
  border-radius: 10px;
  padding: 0;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  min-height: 600px;
  overflow: hidden;
`;

const SectionTitle = styled.h3`
  font-size: 18px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 20px 0;
  padding-bottom: 10px;
  border-bottom: 2px solid #ecf0f1;
`;

const StockInfo = styled.div`
  flex: 1;
`;

const StockName = styled.h1`
  font-size: 28px;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 5px;
`;

const StockCode = styled.span`
  font-size: 16px;
  color: #7f8c8d;
  background-color: #ecf0f1;
  padding: 4px 12px;
  border-radius: 6px;
  margin-right: 10px;
`;

const Market = styled.span`
  font-size: 14px;
  color: #3498db;
  font-weight: 500;
`;

const PriceSection = styled.div`
  text-align: right;
  margin-right: 40px;
`;

const CurrentPrice = styled.div`
  font-size: 32px;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 5px;
`;

const PriceChange = styled.div<{ $isPositive: boolean }>`
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
  font-size: 18px;
  font-weight: 600;
  color: ${props => props.$isPositive ? '#2ecc71' : '#e74c3c'};
`;

const WatchlistButton = styled.button<{ $isInWatchlist: boolean }>`
  background: ${props => props.$isInWatchlist ? '#f39c12' : '#ecf0f1'};
  color: ${props => props.$isInWatchlist ? 'white' : '#7f8c8d'};
  border: none;
  padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 500;
  transition: all 0.2s ease;
  
  &:hover {
    background: ${props => props.$isInWatchlist ? '#e67e22' : '#bdc3c7'};
  }
`;

const ChartTitle = styled.h2`
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 20px;
`;

const TimeButtons = styled.div`
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
`;

const TimeButton = styled.button<{ $active: boolean }>`
  background: ${props => props.$active ? '#3498db' : '#ecf0f1'};
  color: ${props => props.$active ? 'white' : '#7f8c8d'};
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s ease;
  
  &:hover {
    background: ${props => props.$active ? '#2980b9' : '#bdc3c7'};
  }
`;

const StatsGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 20px;
`;

const StatCard = styled.div`
  text-align: center;
`;

const StatTitle = styled.h3`
  font-size: 16px;
  color: #7f8c8d;
  margin-bottom: 10px;
`;

const StatValue = styled.div`
  font-size: 24px;
  font-weight: 700;
  color: #2c3e50;
`;

const OrderTabs = styled.div`
  display: flex;
`;

const OrderTab = styled.button<{ $active: boolean }>`
  flex: 1;
  background: ${props => props.$active ? '#3498db' : '#ecf0f1'};
  color: ${props => props.$active ? 'white' : '#7f8c8d'};
  border: none;
  padding: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  
  &:hover {
    background: ${props => props.$active ? '#2980b9' : '#bdc3c7'};
  }
`;

const OrderForm = styled.div`
  padding: 20px;
`;

const FormGroup = styled.div`
  margin-bottom: 20px;
`;

const Label = styled.label`
  display: block;
  font-size: 14px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 8px;
`;

const Input = styled.input`
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  
  &:focus {
    outline: none;
    border-color: #3498db;
  }
`;

const Select = styled.select`
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  background: white;
  
  &:focus {
    outline: none;
    border-color: #3498db;
  }
`;

const OrderButton = styled.button<{ $orderType: 'buy' | 'sell' }>`
  width: 100%;
  background: ${props => props.$orderType === 'buy' ? '#2ecc71' : '#e74c3c'};
  color: white;
  border: none;
  padding: 15px;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s ease;
  
  &:hover {
    background: ${props => props.$orderType === 'buy' ? '#27ae60' : '#c0392b'};
  }
  
  &:disabled {
    background: #bdc3c7;
    cursor: not-allowed;
  }
`;

const OrderSummary = styled.div`
  background: #f8f9fa;
  padding: 15px;
  border-radius: 6px;
  margin-bottom: 20px;
`;

const SummaryRow = styled.div`
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  
  &:last-child {
    margin-bottom: 0;
    font-weight: 600;
    border-top: 1px solid #ddd;
    padding-top: 8px;
  }
`;

function StockDetail() {
  const { stockCode } = useParams<{ stockCode: string }>();
  const [stock, setStock] = useState<any>(null);
  const [candlestickData, setCandlestickData] = useState<any[]>([]);
  const [timeRange, setTimeRange] = useState(24);
  const [isInWatchlist, setIsInWatchlist] = useState(false);
  const [loading, setLoading] = useState(true);
  
  const [financialData, setFinancialData] = useState<any>(null);
  const [financialLoading, setFinancialLoading] = useState(true);
  
  const [orderType, setOrderType] = useState<'buy' | 'sell'>('buy');
  const [priceType, setPriceType] = useState<'market' | 'limit'>('market');
  const [quantity, setQuantity] = useState('');
  const [price, setPrice] = useState('');
  const [orderLoading, setOrderLoading] = useState(false);

  useEffect(() => {
    if (stockCode) {
      fetchStockData();
      fetchCandlestickData();
      fetchFinancialData();
      
      const interval = setInterval(() => {
        fetchStockData();
        fetchCandlestickData();
      }, 30000);
      
      return () => clearInterval(interval);
    }
  }, [stockCode, timeRange]);

  useEffect(() => {
    if (stock?.id) {
      checkWatchlist();
    }
  }, [stock?.id]);

  const fetchStockData = async () => {
    console.log('fetchStockData 시작:', stockCode);
    try {
      const response = await api.get(`/api/stocks/stock?id=${stockCode}`);
      console.log('주식 데이터 응답:', response.data);
      setStock(response.data);
      if (priceType === 'market') {
        setPrice(response.data.current_price.toString());
      }
    } catch (error) {
      console.error('주식 데이터 로딩 오류:', error);
    } finally {
      console.log('fetchStockData 완료, loading false 설정');
      setLoading(false);
    }
  };

  const fetchCandlestickData = async () => {
    console.log('fetchCandlestickData 시작:', stockCode, 'timeRange:', timeRange);
    try {
      const response = await api.get(`/api/stocks/stock/candlestick?id=${stockCode}&hours=${timeRange}`);
      console.log('캔들차트 데이터 응답 길이:', response.data.length);
      setCandlestickData(response.data);
    } catch (error) {
      console.error('캔들차트 데이터 로딩 오류:', error);
    }
  };

  const fetchFinancialData = async () => {
    if (!stockCode) return;
    console.log('fetchFinancialData 시작:', stockCode);
    try {
      const response = await financialApi.getLatestFinancialStatement(stockCode!);
      console.log('재무제표 데이터 응답:', response.data);
      setFinancialData(response.data.latest_statement);
    } catch (error) {
      console.error('재무제표 데이터 로딩 오류:', error);
    } finally {
      setFinancialLoading(false);
    }
  };

  const checkWatchlist = async () => {
    try {
      if (stock?.id) {
        const response = await api.get(`/api/watchlist/check/${stock.id}`);
        setIsInWatchlist(response.data.in_watchlist);
      }
    } catch (error) {
      console.error('관심종목 확인 오류:', error);
    }
  };

  const toggleWatchlist = async () => {
    try {
      if (isInWatchlist) {
        await api.delete(`/api/watchlist/${stock.id}`);
        setIsInWatchlist(false);
      } else {
        await api.post('/api/watchlist', { stock_id: stock.id });
        setIsInWatchlist(true);
      }
    } catch (error) {
      console.error('관심종목 토글 오류:', error);
    }
  };

  const handleOrder = async () => {
    if (!stock || !price || !quantity) {
      alert('모든 필드를 입력해주세요.');
      return;
    }

    setOrderLoading(true);
    try {
      const orderData = {
        stock_id: stock.id,
        order_type: orderType,
        price_type: priceType,
        price: priceType === 'limit' ? parseFloat(price) : stock.current_price,
        quantity: parseInt(quantity)
      };

      await ordersApi.createOrder(orderData);
      alert(`${orderType === 'buy' ? '매수' : '매도'} 주문이 완료되었습니다.`);
      
      setQuantity('');
      if (priceType === 'limit') {
        setPrice('');
      }
    } catch (error: any) {
      console.error('주문 오류:', error);
      alert(error.response?.data?.detail || '주문에 실패했습니다.');
    } finally {
      setOrderLoading(false);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('ko-KR').format(amount);
  };

  const formatPercent = (percent: number) => {
    return `${percent >= 0 ? '+' : ''}${percent.toFixed(2)}%`;
  };

  const calculateTotal = () => {
    const qty = parseInt(quantity) || 0;
    const prc = parseFloat(price) || 0;
    return qty * prc;
  };

  if (loading) {
    return (
      <Container>
        <div>로딩 중...</div>
      </Container>
    );
  }

  if (!stock) {
    return (
      <Container>
        <div>주식을 찾을 수 없습니다.</div>
      </Container>
    );
  }

  return (
    <Container>
      <HeaderSection>
        <StockInfo>
          <StockName>{stock.name}</StockName>
          <div>
            <StockCode>{stock.code}</StockCode>
            <Market>{stock.market}</Market>
          </div>
        </StockInfo>
        <PriceSection>
          <CurrentPrice>{formatCurrency(stock.current_price)}</CurrentPrice>
          <PriceChange $isPositive={stock.change_percent >= 0}>
            {stock.change_percent >= 0 ? <TrendingUp size={20} /> : <TrendingDown size={20} />}
            {formatPercent(stock.change_percent)}
          </PriceChange>
        </PriceSection>
        <WatchlistButton $isInWatchlist={isInWatchlist} onClick={toggleWatchlist}>
          {isInWatchlist ? <StarOff size={20} /> : <Star size={20} />}
          {isInWatchlist ? '관심종목 해제' : '관심종목 추가'}
        </WatchlistButton>
      </HeaderSection>

      <MiddleSection>
        <ChartSection>
          <ChartTitle>캔들차트</ChartTitle>
          <CandlestickChart data={candlestickData} height={600} />
        </ChartSection>

        <OrderSection>
          <OrderTabs>
            <OrderTab $active={orderType === 'buy'} onClick={() => setOrderType('buy')}>
              매수
            </OrderTab>
            <OrderTab $active={orderType === 'sell'} onClick={() => setOrderType('sell')}>
              매도
            </OrderTab>
          </OrderTabs>

          <OrderForm>
            <FormGroup>
              <Label>주문 유형</Label>
              <Select value={priceType} onChange={(e) => setPriceType(e.target.value as 'market' | 'limit')}>
                <option value="market">시장가</option>
                <option value="limit">지정가</option>
              </Select>
            </FormGroup>

            <FormGroup>
              <Label>수량</Label>
              <Input
                type="number"
                value={quantity}
                onChange={(e) => setQuantity(e.target.value)}
                placeholder="주문 수량을 입력하세요"
                min="1"
              />
            </FormGroup>

            {priceType === 'limit' && (
              <FormGroup>
                <Label>가격</Label>
                <Input
                  type="number"
                  value={price}
                  onChange={(e) => setPrice(e.target.value)}
                  placeholder="주문 가격을 입력하세요"
                  min="0"
                />
              </FormGroup>
            )}

            {quantity && (priceType === 'market' || price) && (
              <OrderSummary>
                <SummaryRow>
                  <span>수량:</span>
                  <span>{parseInt(quantity).toLocaleString()}주</span>
                </SummaryRow>
                <SummaryRow>
                  <span>가격:</span>
                  <span>{formatCurrency(priceType === 'market' ? stock.current_price : parseFloat(price))}</span>
                </SummaryRow>
                <SummaryRow>
                  <span>총 금액:</span>
                  <span>{formatCurrency(priceType === 'market' ? parseInt(quantity) * stock.current_price : calculateTotal())}</span>
                </SummaryRow>
              </OrderSummary>
            )}

            <OrderButton
              $orderType={orderType}
              onClick={handleOrder}
              disabled={orderLoading || !quantity || (priceType === 'limit' && !price)}
            >
              {orderLoading ? '주문 중...' : `${orderType === 'buy' ? '매수' : '매도'} 주문`}
            </OrderButton>
          </OrderForm>
        </OrderSection>
      </MiddleSection>

      <ContentSections>
        <FinancialSection>
          <SectionTitle>재무제표</SectionTitle>
          <StatsGrid>
            <StatCard>
              <StatTitle>시가총액</StatTitle>
              <StatValue>{stock.market_cap ? `${(stock.market_cap / 1000000000000).toFixed(1)}조원` : '408.0조원'}</StatValue>
            </StatCard>
            <StatCard>
              <StatTitle>전일 종가</StatTitle>
              <StatValue>{formatCurrency(stock.previous_close)}</StatValue>
            </StatCard>
            <StatCard>
              <StatTitle>변동금액</StatTitle>
              <StatValue style={{ color: stock.change_amount >= 0 ? '#2ecc71' : '#e74c3c' }}>
                {stock.change_amount >= 0 ? '+' : ''}{formatCurrency(stock.change_amount)}
              </StatValue>
            </StatCard>
            {!financialLoading && financialData && (
              <>
                <StatCard>
                  <StatTitle>매출액</StatTitle>
                  <StatValue>{financialData.revenue ? `${financialData.revenue.toLocaleString()}억원` : 'N/A'}</StatValue>
                </StatCard>
                <StatCard>
                  <StatTitle>영업이익률</StatTitle>
                  <StatValue>{financialData.operating_margin ? `${financialData.operating_margin}%` : 'N/A'}</StatValue>
                </StatCard>
                <StatCard>
                  <StatTitle>ROE</StatTitle>
                  <StatValue>{financialData.roe ? `${financialData.roe}%` : 'N/A'}</StatValue>
                </StatCard>
              </>
            )}
            {(financialLoading || !financialData) && (
              <>
                <StatCard>
                  <StatTitle>매출액</StatTitle>
                  <StatValue>{financialLoading ? '로딩중...' : 'N/A'}</StatValue>
                </StatCard>
                <StatCard>
                  <StatTitle>영업이익률</StatTitle>
                  <StatValue>{financialLoading ? '로딩중...' : 'N/A'}</StatValue>
                </StatCard>
                <StatCard>
                  <StatTitle>ROE</StatTitle>
                  <StatValue>{financialLoading ? '로딩중...' : 'N/A'}</StatValue>
                </StatCard>
              </>
            )}
          </StatsGrid>
          <FinancialStatements stockCode={stockCode!} />
        </FinancialSection>
        <DiscussionSection>
          <SectionTitle style={{ margin: '20px 20px 0 20px' }}>종목토론</SectionTitle>
          <DiscussionBoard stockCode={stockCode!} stockName={stock.name} />
        </DiscussionSection>
      </ContentSections>
    </Container>
  );
}

export default StockDetail; 