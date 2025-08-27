from sqlalchemy import Column, Integer, String, DECIMAL, BIGINT, DateTime, Enum, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base
import enum

class OrderType(enum.Enum):
    buy = "buy"
    sell = "sell"

class PriceType(enum.Enum):
    market = "market"
    limit = "limit"

class OrderStatus(enum.Enum):
    pending = "pending"
    completed = "completed"
    cancelled = "cancelled"

class TransactionType(enum.Enum):
    buy = "buy"
    sell = "sell"

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True, nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    password = Column(String(255))
    cash = Column(DECIMAL(15, 2), default=5000000)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    portfolios = relationship("Portfolio", back_populates="user")
    orders = relationship("Order", back_populates="user")
    watchlists = relationship("Watchlist", back_populates="user")
    transactions = relationship("Transaction", back_populates="user")
    discussions = relationship("Discussion", back_populates="user")
    discussion_comments = relationship("DiscussionComment", back_populates="user")
    discussion_reactions = relationship("DiscussionReaction", back_populates="user")
    comment_reactions = relationship("CommentReaction", back_populates="user")

class Stock(Base):
    __tablename__ = "stocks"
    
    id = Column(Integer, primary_key=True, index=True)
    code = Column(String(10), unique=True, index=True, nullable=False)
    name = Column(String(100), nullable=False)
    market = Column(String(20), nullable=False)
    sector = Column(String(50))
    current_price = Column(DECIMAL(10, 2), nullable=False)
    previous_close = Column(DECIMAL(10, 2), nullable=False)
    market_cap = Column(BIGINT)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    prices = relationship("StockPrice", back_populates="stock")
    volume_details = relationship("VolumeDetail", back_populates="stock")
    portfolios = relationship("Portfolio", back_populates="stock")
    orders = relationship("Order", back_populates="stock")
    watchlists = relationship("Watchlist", back_populates="stock")
    transactions = relationship("Transaction", back_populates="stock")
    financial_statements = relationship("FinancialStatement", back_populates="stock")
    discussions = relationship("Discussion", back_populates="stock")

class StockPrice(Base):
    __tablename__ = "stock_prices"
    
    id = Column(Integer, primary_key=True, index=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    open_price = Column(DECIMAL(10, 2), nullable=False)
    high_price = Column(DECIMAL(10, 2), nullable=False)
    low_price = Column(DECIMAL(10, 2), nullable=False)
    close_price = Column(DECIMAL(10, 2), nullable=False)
    volume = Column(BIGINT, nullable=False)
    timestamp = Column(DateTime(timezone=True), server_default=func.now())
    
    stock = relationship("Stock", back_populates="prices")

class VolumeDetail(Base):
    __tablename__ = "volume_details"
    
    id = Column(Integer, primary_key=True, index=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    individual_volume = Column(BIGINT, nullable=False)
    foreign_volume = Column(BIGINT, nullable=False)
    institutional_volume = Column(BIGINT, nullable=False)
    total_volume = Column(BIGINT, nullable=False)
    timestamp = Column(DateTime(timezone=True), server_default=func.now())
    
    stock = relationship("Stock", back_populates="volume_details")

class Portfolio(Base):
    __tablename__ = "portfolios"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    quantity = Column(Integer, nullable=False)
    average_price = Column(DECIMAL(10, 2), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    user = relationship("User", back_populates="portfolios")
    stock = relationship("Stock", back_populates="portfolios")

class Order(Base):
    __tablename__ = "orders"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    order_type = Column(Enum(OrderType), nullable=False)
    price_type = Column(Enum(PriceType), nullable=False)
    quantity = Column(Integer, nullable=False)
    price = Column(DECIMAL(10, 2))
    status = Column(Enum(OrderStatus), default=OrderStatus.pending)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    executed_at = Column(DateTime(timezone=True))
    
    user = relationship("User", back_populates="orders")
    stock = relationship("Stock", back_populates="orders")

class Watchlist(Base):
    __tablename__ = "watchlists"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User", back_populates="watchlists")
    stock = relationship("Stock", back_populates="watchlists")

class Transaction(Base):
    __tablename__ = "transactions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    transaction_type = Column(Enum(TransactionType), nullable=False)
    quantity = Column(Integer, nullable=False)
    price = Column(DECIMAL(10, 2), nullable=False)
    total_amount = Column(DECIMAL(15, 2), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User", back_populates="transactions")
    stock = relationship("Stock", back_populates="transactions")

class FinancialStatement(Base):
    __tablename__ = "financial_statements"
    
    id = Column(Integer, primary_key=True, index=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    year = Column(Integer, nullable=False)
    quarter = Column(Integer, nullable=False)
    revenue = Column(BIGINT)
    operating_profit = Column(BIGINT)
    net_profit = Column(BIGINT)
    operating_margin = Column(DECIMAL(5, 2))
    net_margin = Column(DECIMAL(5, 2))
    roe = Column(DECIMAL(5, 2))
    debt_ratio = Column(DECIMAL(5, 2))
    quick_ratio = Column(DECIMAL(5, 2))
    retention_ratio = Column(DECIMAL(8, 2))
    eps = Column(Integer)
    per = Column(DECIMAL(5, 2))
    bps = Column(Integer)
    pbr = Column(DECIMAL(5, 2))
    dividend_per_share = Column(Integer)
    dividend_yield = Column(DECIMAL(5, 2))
    payout_ratio = Column(DECIMAL(5, 2))
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    stock = relationship("Stock", back_populates="financial_statements")

class ReactionType(enum.Enum):
    like = "like"
    dislike = "dislike"

class Discussion(Base):
    __tablename__ = "discussions"
    
    id = Column(Integer, primary_key=True, index=True)
    stock_id = Column(Integer, ForeignKey("stocks.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)
    views = Column(Integer, default=0)
    likes_count = Column(Integer, default=0)
    dislikes_count = Column(Integer, default=0)
    comments_count = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    stock = relationship("Stock", back_populates="discussions")
    user = relationship("User", back_populates="discussions")
    comments = relationship("DiscussionComment", back_populates="discussion", cascade="all, delete-orphan")
    reactions = relationship("DiscussionReaction", back_populates="discussion", cascade="all, delete-orphan")

class DiscussionComment(Base):
    __tablename__ = "discussion_comments"
    
    id = Column(Integer, primary_key=True, index=True)
    discussion_id = Column(Integer, ForeignKey("discussions.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    content = Column(Text, nullable=False)
    likes_count = Column(Integer, default=0)
    dislikes_count = Column(Integer, default=0)
    parent_id = Column(Integer, ForeignKey("discussion_comments.id"), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    discussion = relationship("Discussion", back_populates="comments")
    user = relationship("User", back_populates="discussion_comments")
    parent = relationship("DiscussionComment", remote_side=[id], back_populates="replies")
    replies = relationship("DiscussionComment", back_populates="parent", cascade="all, delete-orphan")
    reactions = relationship("CommentReaction", back_populates="comment", cascade="all, delete-orphan")

class DiscussionReaction(Base):
    __tablename__ = "discussion_reactions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    discussion_id = Column(Integer, ForeignKey("discussions.id"), nullable=False)
    reaction_type = Column(Enum(ReactionType), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User", back_populates="discussion_reactions")
    discussion = relationship("Discussion", back_populates="reactions")

class CommentReaction(Base):
    __tablename__ = "comment_reactions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    comment_id = Column(Integer, ForeignKey("discussion_comments.id"), nullable=False)
    reaction_type = Column(Enum(ReactionType), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    user = relationship("User", back_populates="comment_reactions")
    comment = relationship("DiscussionComment", back_populates="reactions") 