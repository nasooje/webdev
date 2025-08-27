import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import { BarChart3, TrendingUp, TrendingDown } from 'lucide-react';
import { financialApi } from '../services/api';

const Container = styled.div`
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-top: 20px;
`;

const Header = styled.div`
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
`;

const Title = styled.h2`
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
`;

const TabContainer = styled.div`
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
`;

const Tab = styled.button<{ $active: boolean }>`
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

const FinancialGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
`;

const FinancialCard = styled.div`
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  text-align: center;
`;

const FinancialLabel = styled.div`
  font-size: 14px;
  color: #7f8c8d;
  margin-bottom: 8px;
`;

const FinancialValue = styled.div<{ $isPositive?: boolean | null }>`
  font-size: 18px;
  font-weight: 600;
  color: ${props => 
    props.$isPositive === true ? '#2ecc71' : 
    props.$isPositive === false ? '#e74c3c' : 
    '#2c3e50'};
`;

const QuarterlyGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
  margin-top: 20px;
`;

const QuarterCard = styled.div`
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
`;

const QuarterTitle = styled.div`
  font-size: 14px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 10px;
  text-align: center;
`;

const QuarterValue = styled.div`
  font-size: 12px;
  color: #7f8c8d;
  margin-bottom: 5px;
`;

interface FinancialStatementsProps {
  stockCode: string;
}

interface FinancialData {
  id: number;
  year: number;
  quarter: number;
  revenue: number | null;
  operating_profit: number | null;
  net_profit: number | null;
  operating_margin: number | null;
  net_margin: number | null;
  roe: number | null;
  eps: number | null;
  per: number | null;
  bps: number | null;
  pbr: number | null;
  debt_ratio: number | null;
  quick_ratio: number | null;
  dividend_per_share: number | null;
  dividend_yield: number | null;
}

function FinancialStatements({ stockCode }: FinancialStatementsProps) {
  const [activeTab, setActiveTab] = useState<'latest' | 'yearly' | 'quarterly'>('latest');
  const [latestData, setLatestData] = useState<FinancialData | null>(null);
  const [yearlyData, setYearlyData] = useState<FinancialData[]>([]);
  const [quarterlyData, setQuarterlyData] = useState<FinancialData[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchFinancialData();
  }, [stockCode]);

  const fetchFinancialData = async () => {
    try {
      setLoading(true);
      
      const latestResponse = await financialApi.getLatestFinancialStatement(stockCode);
      setLatestData(latestResponse.data.latest_statement);
      
      const yearlyResponse = await financialApi.getYearlyStatements(stockCode);
      setYearlyData(yearlyResponse.data.yearly_summary);
      
      const currentYear = new Date().getFullYear();
      const quarterlyResponse = await financialApi.getFinancialStatements(stockCode, currentYear - 1);
      setQuarterlyData(quarterlyResponse.data.financial_statements || []);
      
    } catch (error) {
      console.error('재무제표 데이터 로딩 오류:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (amount: number | null) => {
    if (amount === null) return 'N/A';
    return `${amount.toLocaleString()}억원`;
  };

  const formatPercent = (percent: number | null) => {
    if (percent === null) return 'N/A';
    return `${percent}%`;
  };

  const formatNumber = (num: number | null) => {
    if (num === null) return 'N/A';
    return num.toLocaleString();
  };

  const renderLatestData = () => {
    if (!latestData) return <div>데이터가 없습니다.</div>;

    return (
      <FinancialGrid>
        <FinancialCard>
          <FinancialLabel>매출액</FinancialLabel>
          <FinancialValue>{formatCurrency(latestData.revenue)}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>영업이익</FinancialLabel>
          <FinancialValue>{formatCurrency(latestData.operating_profit)}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>당기순이익</FinancialLabel>
          <FinancialValue>{formatCurrency(latestData.net_profit)}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>영업이익률</FinancialLabel>
          <FinancialValue $isPositive={latestData.operating_margin ? latestData.operating_margin > 0 : null}>
            {formatPercent(latestData.operating_margin)}
          </FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>ROE</FinancialLabel>
          <FinancialValue $isPositive={latestData.roe ? latestData.roe > 0 : null}>
            {formatPercent(latestData.roe)}
          </FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>EPS</FinancialLabel>
          <FinancialValue>{latestData.eps ? `${formatNumber(latestData.eps)}원` : 'N/A'}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>PER</FinancialLabel>
          <FinancialValue>{latestData.per ? `${latestData.per}배` : 'N/A'}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>PBR</FinancialLabel>
          <FinancialValue>{latestData.pbr ? `${latestData.pbr}배` : 'N/A'}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>부채비율</FinancialLabel>
          <FinancialValue>{formatPercent(latestData.debt_ratio)}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>당좌비율</FinancialLabel>
          <FinancialValue>{formatPercent(latestData.quick_ratio)}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>주당배당금</FinancialLabel>
          <FinancialValue>{latestData.dividend_per_share ? `${formatNumber(latestData.dividend_per_share)}원` : 'N/A'}</FinancialValue>
        </FinancialCard>
        <FinancialCard>
          <FinancialLabel>배당수익률</FinancialLabel>
          <FinancialValue>{formatPercent(latestData.dividend_yield)}</FinancialValue>
        </FinancialCard>
      </FinancialGrid>
    );
  };

  const renderYearlyData = () => {
    return (
      <QuarterlyGrid>
        {yearlyData.slice(0, 4).map((data, index) => (
          <QuarterCard key={data.id}>
            <QuarterTitle>{data.year}년</QuarterTitle>
            <QuarterValue>매출액: {formatCurrency(data.revenue)}</QuarterValue>
            <QuarterValue>영업이익률: {formatPercent(data.operating_margin)}</QuarterValue>
            <QuarterValue>ROE: {formatPercent(data.roe)}</QuarterValue>
            <QuarterValue>EPS: {data.eps ? `${formatNumber(data.eps)}원` : 'N/A'}</QuarterValue>
          </QuarterCard>
        ))}
      </QuarterlyGrid>
    );
  };

  const renderQuarterlyData = () => {
    return (
      <QuarterlyGrid>
        {quarterlyData.slice(0, 4).map((data, index) => (
          <QuarterCard key={data.id}>
            <QuarterTitle>{data.year}년 {data.quarter}분기</QuarterTitle>
            <QuarterValue>매출액: {formatCurrency(data.revenue)}</QuarterValue>
            <QuarterValue>영업이익률: {formatPercent(data.operating_margin)}</QuarterValue>
            <QuarterValue>ROE: {formatPercent(data.roe)}</QuarterValue>
            <QuarterValue>EPS: {data.eps ? `${formatNumber(data.eps)}원` : 'N/A'}</QuarterValue>
          </QuarterCard>
        ))}
      </QuarterlyGrid>
    );
  };

  if (loading) {
    return (
      <Container>
        <Header>
          <BarChart3 size={24} color="#3498db" />
          <Title>기업실적분석</Title>
        </Header>
        <div>로딩 중...</div>
      </Container>
    );
  }

  return (
    <Container>
      <Header>
        <BarChart3 size={24} color="#3498db" />
        <Title>기업실적분석</Title>
      </Header>
      
      <TabContainer>
        <Tab $active={activeTab === 'latest'} onClick={() => setActiveTab('latest')}>
          최신 실적
        </Tab>
        <Tab $active={activeTab === 'yearly'} onClick={() => setActiveTab('yearly')}>
          연도별 실적
        </Tab>
        <Tab $active={activeTab === 'quarterly'} onClick={() => setActiveTab('quarterly')}>
          분기별 실적
        </Tab>
      </TabContainer>

      {activeTab === 'latest' && renderLatestData()}
      {activeTab === 'yearly' && renderYearlyData()}
      {activeTab === 'quarterly' && renderQuarterlyData()}
    </Container>
  );
}

export default FinancialStatements; 