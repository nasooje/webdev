import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import styled from 'styled-components';
import { useAuth } from '../contexts/AuthContext';

const RegisterContainer = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  position: relative;
  
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
    opacity: 0.3;
  }
`;

const RegisterCard = styled.div`
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  padding: 50px 40px;
  border-radius: 12px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  width: 100%;
  max-width: 450px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
  z-index: 1;
`;

const LogoSection = styled.div`
  text-align: center;
  margin-bottom: 40px;
`;

const Title = styled.h1`
  color: #1a365d;
  font-size: 28px;
  font-weight: 700;
  margin: 0 0 8px 0;
  letter-spacing: -0.5px;
`;

const Subtitle = styled.p`
  color: #4a5568;
  font-size: 15px;
  margin: 0;
  font-weight: 500;
`;

const Form = styled.form`
  display: flex;
  flex-direction: column;
  gap: 20px;
`;

const InputGroup = styled.div`
  display: flex;
  flex-direction: column;
  gap: 8px;
`;

const Label = styled.label`
  font-weight: 600;
  color: #2d3748;
  font-size: 14px;
  letter-spacing: 0.3px;
`;

const Input = styled.input`
  padding: 14px 16px;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  font-size: 16px;
  background: #ffffff;
  transition: all 0.2s ease;
  
  &:focus {
    outline: none;
    border-color: #3182ce;
    box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
  }
  
  &::placeholder {
    color: #a0aec0;
  }
`;

const Button = styled.button`
  background: #3182ce;
  color: white;
  border: none;
  padding: 16px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  margin-top: 8px;
  
  &:hover {
    background: #2c5282;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(49, 130, 206, 0.3);
  }
  
  &:active {
    transform: translateY(0);
  }
  
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
  }
`;

const ErrorMessage = styled.div`
  color: #e53e3e;
  text-align: center;
  margin-top: 12px;
  font-size: 14px;
  font-weight: 500;
  padding: 12px;
  background: rgba(254, 178, 178, 0.2);
  border-radius: 6px;
  border-left: 4px solid #e53e3e;
`;

const SuccessMessage = styled.div`
  color: #38a169;
  text-align: center;
  margin-top: 12px;
  font-size: 14px;
  font-weight: 500;
  padding: 12px;
  background: rgba(154, 230, 180, 0.2);
  border-radius: 6px;
  border-left: 4px solid #38a169;
`;

const LinkText = styled.p`
  text-align: center;
  margin-top: 32px;
  color: #718096;
  font-size: 15px;
  
  a {
    color: #3182ce;
    text-decoration: none;
    font-weight: 600;
    
    &:hover {
      text-decoration: underline;
      color: #2c5282;
    }
  }
`;

const MarketInfo = styled.div`
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.9);
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 12px;
  color: #4a5568;
  
  .market-status {
    color: #38a169;
    font-weight: 600;
  }
`;

function Register() {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  
  const { register } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: any) => {
    e.preventDefault();
    
    if (password !== confirmPassword) {
      setError('비밀번호가 일치하지 않습니다.');
      return;
    }
    
    setLoading(true);
    setError('');
    setSuccess('');

    try {
      await register(username, email, password);
      
      setUsername('');
      setEmail('');
      setPassword('');
      setConfirmPassword('');
      
      setSuccess('회원가입이 완료되었습니다! 로그인 페이지로 이동합니다.');
      
      setTimeout(() => {
        navigate('/login?registered=true', { replace: true });
      }, 2000);
      
    } catch (err: any) {
      console.error('Registration error:', err);
      setError(err.response?.data?.detail || '회원가입에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <RegisterContainer>
      <RegisterCard>
        <LogoSection>
          <Title>SUCCESS STOCK</Title>
          <Subtitle>전문 투자자를 위한 계정 생성</Subtitle>
        </LogoSection>
        
        <Form onSubmit={handleSubmit}>
          <InputGroup>
            <Label htmlFor="username">사용자명</Label>
            <Input
              id="username"
              type="text"
              value={username}
              onChange={(e: any) => setUsername(e.target.value)}
              placeholder="사용자명을 입력하세요"
              required
            />
          </InputGroup>
          
          <InputGroup>
            <Label htmlFor="email">이메일</Label>
            <Input
              id="email"
              type="email"
              value={email}
              onChange={(e: any) => setEmail(e.target.value)}
              placeholder="이메일 주소를 입력하세요"
              required
            />
          </InputGroup>
          
          <InputGroup>
            <Label htmlFor="password">비밀번호</Label>
            <Input
              id="password"
              type="password"
              value={password}
              onChange={(e: any) => setPassword(e.target.value)}
              placeholder="안전한 비밀번호를 입력하세요"
              required
            />
          </InputGroup>
          
          <InputGroup>
            <Label htmlFor="confirmPassword">비밀번호 확인</Label>
            <Input
              id="confirmPassword"
              type="password"
              value={confirmPassword}
              onChange={(e: any) => setConfirmPassword(e.target.value)}
              placeholder="비밀번호를 다시 입력하세요"
              required
            />
          </InputGroup>
          
          <Button type="submit" disabled={loading}>
            {loading ? '계정 생성 중...' : '계정 생성'}
          </Button>
          
          {error && <ErrorMessage>{error}</ErrorMessage>}
          {success && <SuccessMessage>{success}</SuccessMessage>}
        </Form>
        
        <LinkText>
          이미 계정이 있으신가요? <Link to="/login">로그인</Link>
        </LinkText>
      </RegisterCard>
    </RegisterContainer>
  );
}

export default Register; 