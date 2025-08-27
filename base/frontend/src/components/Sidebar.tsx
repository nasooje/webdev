import React, { useState, useEffect } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import styled from 'styled-components';
import { Home, Briefcase, ShoppingCart, Star } from 'lucide-react';

const SidebarContainer = styled.nav`
  width: 250px;
  background-color: #34495e;
  color: white;
  padding: 20px 0;
  overflow-y: auto;
`;

const SidebarSection = styled.div`
  margin-bottom: 30px;
`;

const SectionTitle = styled.h3`
  font-size: 14px;
  font-weight: 600;
  color: #bdc3c7;
  margin-bottom: 10px;
  padding: 0 20px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
`;

const NavItem = styled(Link)<{ $isActive: boolean }>`
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: ${props => props.$isActive ? '#3498db' : '#ecf0f1'};
  text-decoration: none;
  background-color: ${props => props.$isActive ? '#2c3e50' : 'transparent'};
  border-right: ${props => props.$isActive ? '3px solid #3498db' : 'none'};
  transition: all 0.2s ease;
  
  &:hover {
    background-color: #2c3e50;
    color: #3498db;
  }
  
  svg {
    margin-right: 12px;
  }
`;

const StockList = styled.div`
  padding: 0 20px;
`;

const StockItem = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #2c3e50;
  cursor: pointer;
  text-decoration: none;
  color: inherit;
  
  &:hover {
    background-color: #2c3e50;
    margin: 0 -20px;
    padding-left: 20px;
    padding-right: 20px;
  }
`;

const StockName = styled.span`
  font-size: 14px;
  color: #ecf0f1;
`;

const StockPrice = styled.span<{ $isPositive: boolean }>`
  font-size: 12px;
  font-weight: bold;
  color: ${props => props.$isPositive ? '#2ecc71' : '#e74c3c'};
`;

interface Stock {
  id: number;
  code: string;
  name: string;
  current_price: number;
  change_percent: number;
}

function Sidebar() {
  const location = useLocation();
  const navigate = useNavigate();

  const isActive = (path: string) => location.pathname === path;

  const handleStockClick = (stockCode: string) => {
    navigate(`/stock/${stockCode}`);
  };

  return (
    <SidebarContainer>
      <SidebarSection>
        <SectionTitle>메뉴</SectionTitle>
        <NavItem to="/" $isActive={isActive('/')}>
          <Home size={20} />
          대시보드
        </NavItem>
        <NavItem to="/portfolio" $isActive={isActive('/portfolio')}>
          <Briefcase size={20} />
          포트폴리오
        </NavItem>
        <NavItem to="/orders" $isActive={isActive('/orders')}>
          <ShoppingCart size={20} />
          주문내역
        </NavItem>
        <NavItem to="/watchlist" $isActive={isActive('/watchlist')}>
          <Star size={20} />
          관심종목
        </NavItem>
      </SidebarSection>
    </SidebarContainer>
  );
}

export default Sidebar; 