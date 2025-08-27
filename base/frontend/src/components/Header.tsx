import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';
import { Search, User, LogOut } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { stocksApi } from '../services/api';

const HeaderContainer = styled.header`
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  height: 60px;
  background-color: #2c3e50;
  color: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
`;

const Logo = styled.div`
  font-size: 24px;
  font-weight: bold;
  color: #3498db;
`;

const RightSection = styled.div`
  display: flex;
  align-items: center;
  gap: 24px;
`;

const SearchWrapper = styled.div`
  position: relative;
  z-index: 1000;
`;

const SearchContainer = styled.div`
  display: flex;
  align-items: center;
  background-color: #34495e;
  border-radius: 20px;
  padding: 8px 16px;
  min-width: 350px;
  transition: all 0.2s ease;
  
  &:focus-within {
    background-color: #3c5a78;
    box-shadow: 0 0 0 2px #3498db;
  }
`;

const SearchInput = styled.input`
  background: none;
  border: none;
  color: white;
  margin-left: 8px;
  outline: none;
  width: 100%;
  font-size: 14px;
  
  &::placeholder {
    color: #bdc3c7;
  }
`;

const SearchResults = styled.div<{ $show: boolean }>`
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  max-height: 300px;
  overflow-y: auto;
  display: ${props => props.$show ? 'block' : 'none'};
  margin-top: 4px;
  z-index: 1001;
`;

const SearchResultItem = styled.div`
  padding: 12px 16px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background-color 0.2s ease;
  
  &:hover {
    background-color: #f8f9fa;
  }
  
  &:last-child {
    border-bottom: none;
  }
`;

const StockName = styled.div`
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 4px;
`;

const StockInfo = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const StockCode = styled.span`
  font-size: 12px;
  color: #7f8c8d;
  background-color: #ecf0f1;
  padding: 2px 6px;
  border-radius: 4px;
`;

const StockPrice = styled.span<{ $isPositive: boolean }>`
  font-weight: 600;
  color: ${props => props.$isPositive ? '#e74c3c' : '#3498db'};
`;

const NoResults = styled.div`
  padding: 16px;
  text-align: center;
  color: #7f8c8d;
  font-size: 14px;
`;

const UserSection = styled.div`
  display: flex;
  align-items: center;
  gap: 16px;
`;

const UserInfo = styled.div`
  display: flex;
  align-items: center;
  gap: 8px;
`;

const CashAmount = styled.span`
  font-weight: bold;
  color: #2ecc71;
`;

const LogoutButton = styled.button`
  background: none;
  border: none;
  color: white;
  cursor: pointer;
  padding: 8px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  
  &:hover {
    background-color: #34495e;
  }
`;

function Header() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<any[]>([]);
  const [showResults, setShowResults] = useState(false);
  const [isSearching, setIsSearching] = useState(false);
  const searchRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (searchRef.current && !searchRef.current.contains(event.target as Node)) {
        setShowResults(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  useEffect(() => {
    const delayedSearch = setTimeout(() => {
      if (searchQuery.trim()) {
        performSearch(searchQuery);
      } else {
        setSearchResults([]);
        setShowResults(false);
      }
    }, 300);

    return () => clearTimeout(delayedSearch);
  }, [searchQuery]);

  const performSearch = async (query: string) => {
    if (query.length < 2) return;
    
    setIsSearching(true);
    try {
      const response = await stocksApi.getStocks(query);
      setSearchResults(response.data.slice(0, 10));
      setShowResults(true);
    } catch (error) {
      console.error('검색 오류:', error);
      setSearchResults([]);
    } finally {
      setIsSearching(false);
    }
  };

  const handleStockSelect = (stock: any) => {
    navigate(`/stock/${stock.code}`);
    setSearchQuery('');
    setShowResults(false);
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('ko-KR').format(amount) + ' 원';
  };

  return (
    <HeaderContainer>
      <Logo>성공 증권</Logo>
      
      <RightSection>
        <SearchWrapper ref={searchRef}>
          <SearchContainer>
            <Search size={20} color="#bdc3c7" />
            <SearchInput
              type="text"
              placeholder="종목명 또는 종목코드를 입력하세요... (예: 코리아텍, 005930)"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              onFocus={() => searchQuery && setShowResults(true)}
            />
          </SearchContainer>
          
          <SearchResults $show={showResults}>
            {isSearching ? (
              <NoResults>검색 중...</NoResults>
            ) : searchResults.length > 0 ? (
              searchResults.map((stock) => (
                <SearchResultItem 
                  key={stock.id} 
                  onClick={() => handleStockSelect(stock)}
                >
                  <StockName>{stock.name}</StockName>
                  <StockInfo>
                    <StockCode>{stock.code}</StockCode>
                    <StockPrice $isPositive={stock.change_percent >= 0}>
                      {stock.current_price.toLocaleString()}원 
                      ({stock.change_percent >= 0 ? '+' : ''}{stock.change_percent.toFixed(2)}%)
                    </StockPrice>
                  </StockInfo>
                </SearchResultItem>
              ))
            ) : searchQuery.length > 0 && !isSearching ? (
              <NoResults>검색 결과가 없습니다.</NoResults>
            ) : null}
          </SearchResults>
        </SearchWrapper>
        
        <UserSection>
          <UserInfo>
            <User size={20} />
            <span>{user?.username}</span>
            <CashAmount>{formatCurrency(user?.cash || 0)}</CashAmount>
          </UserInfo>
          
          <LogoutButton onClick={logout}>
            <LogOut size={20} />
          </LogoutButton>
        </UserSection>
      </RightSection>
    </HeaderContainer>
  );
}

export default Header; 