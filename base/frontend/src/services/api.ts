import axios from 'axios';

const getApiBaseURL = () => {
  if (process.env.REACT_APP_API_URL) {
    return process.env.REACT_APP_API_URL;
  }
  
  if (typeof window !== 'undefined') {
    const protocol = window.location.protocol;
    const hostname = window.location.hostname;
    return `${protocol}//${hostname}:8000`;
  }
  
  return 'http://localhost:8000';
};

export const api = axios.create({
  baseURL: getApiBaseURL(),
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

api.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response?.status === 401) {
      if (!window.location.pathname.includes('/login')) {
        localStorage.removeItem('token');
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export const stocksApi = {
  getStocks: (search?: string) => 
    api.get('/api/stocks', { params: { search } }),
  getStock: (stockId: number) => 
    api.get(`/api/stocks/${stockId}`),
  getStockPrices: (stockId: number, hours: number = 24) => 
    api.get(`/api/stocks/${stockId}/prices`, { params: { hours } }),
  getCandlestickData: (stockId: number, hours: number = 24) => 
    api.get(`/api/stocks/${stockId}/candlestick`, { params: { hours } }),
  getStockVolume: (stockId: number, hours: number = 24) => 
    api.get(`/api/stocks/${stockId}/volume`, { params: { hours } }),
  getMarketSummary: () => 
    api.get('/api/stocks/market/summary'),
  getTopMovers: (type: 'gainers' | 'losers' = 'gainers', limit: number = 10) => 
    api.get('/api/stocks/market/top-movers', { params: { type, limit } }),
};

export const portfolioApi = {
  getPortfolio: () => 
    api.get('/api/portfolio'),
  getPortfolioItem: (stockId: number) => 
    api.get(`/api/portfolio/${stockId}`),
};

export const ordersApi = {
  createOrder: (order: {
    stock_id: number;
    order_type: 'buy' | 'sell';
    price_type: 'market' | 'limit';
    quantity: number;
    price?: number;
  }) => api.post('/api/orders', order),
  getOrders: (status?: string) => 
    api.get('/api/orders', { params: { status } }),
  cancelOrder: (orderId: number) => 
    api.delete(`/api/orders/${orderId}`),
};

export const watchlistApi = {
  getWatchlist: () => 
    api.get('/api/watchlist'),
  addToWatchlist: (stockId: number) => 
    api.post('/api/watchlist', { stock_id: stockId }),
  removeFromWatchlist: (stockId: number) => 
    api.delete(`/api/watchlist/${stockId}`),
  checkInWatchlist: (stockId: number) => 
    api.get(`/api/watchlist/check/${stockId}`),
};

export const financialApi = {
  getFinancialStatements: (stockCode: string, year?: number, quarter?: number) => {
    const params = new URLSearchParams();
    if (year) params.append('year', year.toString());
    if (quarter) params.append('quarter', quarter.toString());
    const queryString = params.toString();
    return api.get(`/api/financial/stock/${stockCode}${queryString ? `?${queryString}` : ''}`);
  },
  
  getLatestFinancialStatement: (stockCode: string) => {
    return api.get(`/api/financial/stock/${stockCode}/latest`);
  },
  
  getYearlyStatements: (stockCode: string) => {
    return api.get(`/api/financial/stock/${stockCode}/yearly`);
  },
  
  compareStocks: (stockCodes: string[]) => {
    return api.post('/api/financial/comparison', { stock_codes: stockCodes });
  }
};

export const discussionsApi = {
  getDiscussions: (stockCode: string, page = 1, limit = 20, sortBy = 'latest') => {
    return api.get(`/api/discussions/stock/${stockCode}?page=${page}&limit=${limit}&sort_by=${sortBy}`);
  },
  
  getDiscussion: (discussionId: number) => {
    return api.get(`/api/discussions/post/${discussionId}`);
  },
  
  createDiscussion: (stockCode: string, data: { title: string; content: string }) => {
    return api.post(`/api/discussions/stock/${stockCode}`, data);
  },
  
  createComment: (discussionId: number, data: { content: string; parent_id?: number }) => {
    return api.post(`/api/discussions/post/${discussionId}/comments`, data);
  },
  
  reactToDiscussion: (discussionId: number, reactionType: 'like' | 'dislike') => {
    return api.post(`/api/discussions/post/${discussionId}/reaction`, {
      reaction_type: reactionType
    });
  },
  
  reactToComment: (commentId: number, reactionType: 'like' | 'dislike') => {
    return api.post(`/api/discussions/comment/${commentId}/reaction`, {
      reaction_type: reactionType
    });
  },
  
  previewDiscussion: (data: { title: string; content: string }) => {
    return api.post('/api/discussions/preview', data);
  }
};

export const authApi = {
  login: (username: string, password: string) => 
    api.post('/api/auth/login', { username, password }),
  
  register: (username: string, email: string, password: string) => 
    api.post('/api/auth/register', { username, email, password }),
  
  getCurrentUser: () => 
    api.get('/api/auth/me'),
  
  logout: () => {
    localStorage.removeItem('token');
    localStorage.removeItem('currentUser');
  }
};  