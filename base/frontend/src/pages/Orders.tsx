import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import { ShoppingCart, TrendingUp, TrendingDown, Clock, CheckCircle, XCircle } from 'lucide-react';
import { ordersApi } from '../services/api';

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

const FilterTabs = styled.div`
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
`;

const FilterTab = styled.button<{ $active: boolean }>`
  background: ${(props: any) => props.$active ? '#3498db' : '#ecf0f1'};
  color: ${(props: any) => props.$active ? 'white' : '#7f8c8d'};
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s ease;
  
  &:hover {
    background: ${(props: any) => props.$active ? '#2980b9' : '#bdc3c7'};
  }
`;

const OrdersContainer = styled.div`
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
`;

const OrdersList = styled.div`
  padding: 0;
`;

const OrderItem = styled.div`
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr 1fr 1fr 1fr;
  gap: 20px;
  padding: 20px;
  border-bottom: 1px solid #f8f9fa;
  align-items: center;
  
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

const OrderValue = styled.div`
  text-align: center;
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

const OrderType = styled.div<{ $isBuy: boolean }>`
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  color: ${(props: any) => props.$isBuy ? '#2ecc71' : '#e74c3c'};
  font-weight: 600;
`;

const OrderStatus = styled.div<{ $status: string }>`
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  color: ${(props: any) => 
    props.$status === 'completed' ? '#2ecc71' : 
    props.$status === 'cancelled' ? '#e74c3c' : '#f39c12'};
  font-weight: 500;
`;

const CancelButton = styled.button`
  background: #e74c3c;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  font-weight: 500;
  transition: background 0.2s ease;
  
  &:hover {
    background: #c0392b;
  }
  
  &:disabled {
    background: #bdc3c7;
    cursor: not-allowed;
  }
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

function Orders() {
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeFilter, setActiveFilter] = useState('all');

  useEffect(() => {
    fetchOrders();
    
    const interval = setInterval(() => {
      fetchOrders();
    }, 30000);
    
    return () => clearInterval(interval);
  }, [activeFilter]);

  const fetchOrders = async () => {
    try {
      const status = activeFilter === 'all' ? undefined : activeFilter;
      const response = await ordersApi.getOrders(status);
      setOrders(response.data);
    } catch (error) {
      console.error('주문내역 로딩 오류:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleCancelOrder = async (orderId: number) => {
    try {
      await ordersApi.cancelOrder(orderId);
      fetchOrders();
    } catch (error) {
      console.error('주문 취소 오류:', error);
      alert('주문 취소에 실패했습니다.');
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('ko-KR').format(amount) + '원';
  };

  const formatDateTime = (dateString: string) => {
    return new Date(dateString).toLocaleString('ko-KR');
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'completed':
        return <CheckCircle size={16} />;
      case 'cancelled':
        return <XCircle size={16} />;
      default:
        return <Clock size={16} />;
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'completed':
        return '체결완료';
      case 'cancelled':
        return '취소됨';
      default:
        return '대기중';
    }
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
        <Title>주문내역</Title>
        <Subtitle>매수/매도 주문 내역을 확인하세요</Subtitle>
      </Header>

      <FilterTabs>
        <FilterTab $active={activeFilter === 'all'} onClick={() => setActiveFilter('all')}>
          전체
        </FilterTab>
        <FilterTab $active={activeFilter === 'pending'} onClick={() => setActiveFilter('pending')}>
          대기중
        </FilterTab>
        <FilterTab $active={activeFilter === 'completed'} onClick={() => setActiveFilter('completed')}>
          체결완료
        </FilterTab>
        <FilterTab $active={activeFilter === 'cancelled'} onClick={() => setActiveFilter('cancelled')}>
          취소됨
        </FilterTab>
      </FilterTabs>

      <OrdersContainer>
        {orders.length === 0 ? (
          <EmptyState>
            <EmptyIcon>📋</EmptyIcon>
            <EmptyText>주문 내역이 없습니다</EmptyText>
            <EmptySubtext>주식을 매수하거나 매도해보세요</EmptySubtext>
          </EmptyState>
        ) : (
          <OrdersList>
            {orders.map((order: any) => (
              <OrderItem key={order.id}>
                <StockInfo>
                  <StockName>{order.stock_name}</StockName>
                  <StockCode>{order.stock_code}</StockCode>
                </StockInfo>
                
                <OrderType $isBuy={order.order_type === 'buy'}>
                  {order.order_type === 'buy' ? <TrendingUp size={16} /> : <TrendingDown size={16} />}
                  {order.order_type === 'buy' ? '매수' : '매도'}
                </OrderType>
                
                <OrderValue>
                  <ValueLabel>주문 유형</ValueLabel>
                  <ValueAmount>{order.price_type === 'market' ? '시장가' : '지정가'}</ValueAmount>
                </OrderValue>
                
                <OrderValue>
                  <ValueLabel>수량</ValueLabel>
                  <ValueAmount>{order.quantity.toLocaleString()}주</ValueAmount>
                </OrderValue>
                
                <OrderValue>
                  <ValueLabel>가격</ValueLabel>
                  <ValueAmount>
                    {order.price ? formatCurrency(order.price) : '시장가'}
                  </ValueAmount>
                </OrderValue>
                
                <OrderValue>
                  <ValueLabel>주문시간</ValueLabel>
                  <ValueAmount>{formatDateTime(order.created_at)}</ValueAmount>
                </OrderValue>
                
                <OrderValue>
                  <ValueLabel>상태</ValueLabel>
                  <OrderStatus $status={order.status}>
                    {getStatusIcon(order.status)}
                    {getStatusText(order.status)}
                  </OrderStatus>
                  {order.status === 'pending' && (
                    <CancelButton onClick={() => handleCancelOrder(order.id)}>
                      취소
                    </CancelButton>
                  )}
                </OrderValue>
              </OrderItem>
            ))}
          </OrdersList>
        )}
      </OrdersContainer>
    </Container>
  );
}

export default Orders;
