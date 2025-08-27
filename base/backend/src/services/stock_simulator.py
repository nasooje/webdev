import random
import threading
import time
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from sqlalchemy.orm import Session
from database import SessionLocal
from models import Stock, StockPrice, VolumeDetail

stock_trends = {}
KST = timezone(timedelta(hours=9))

def get_stock_trend(stock_id):
    if stock_id not in stock_trends:
        stock_trends[stock_id] = {
            'trend': random.choice(['bullish', 'bearish', 'sideways']),
            'momentum': random.uniform(0.3, 1.0),
            'volatility': random.uniform(0.5, 2.0),
            'trend_duration': random.randint(5, 20),
            'current_duration': 0
        }
    return stock_trends[stock_id]

def update_stock_trends():
    for stock_id, trend_data in stock_trends.items():
        trend_data['current_duration'] += 1
        
        if trend_data['current_duration'] >= trend_data['trend_duration']:
            trend_data['trend'] = random.choice(['bullish', 'bearish', 'sideways'])
            trend_data['momentum'] = random.uniform(0.3, 1.5)
            trend_data['volatility'] = random.uniform(0.5, 2.5)
            trend_data['trend_duration'] = random.randint(5, 25)
            trend_data['current_duration'] = 0

def generate_realistic_price_change(current_price, trend_data, previous_close):
    base_volatility = 0.02 
    volatility = base_volatility * trend_data['volatility']
    momentum = trend_data['momentum']
    
    if trend_data['trend'] == 'bullish':
        trend_bias = 0.6
    elif trend_data['trend'] == 'bearish':
        trend_bias = -0.6
    else:
        trend_bias = random.uniform(-0.1, 0.1)
    
    random_component = random.gauss(0, volatility)
    trend_component = trend_bias * momentum * 0.01
    
    if random.random() < 0.05:
        shock_factor = random.uniform(-1.5, 1.5) * volatility
        random_component += shock_factor
    
    distance_from_base = (current_price - previous_close) / previous_close
    reversion_force = -distance_from_base * 0.3
    
    total_change = random_component + trend_component + reversion_force
    
    total_change = max(-0.10, min(0.10, total_change))
    
    return total_change

def generate_realistic_ohlc(open_price, close_price):
    price_range = abs(close_price - open_price)
    
    volatility_factor = random.uniform(1.2, 3.0)
    range_extension = price_range * volatility_factor + (open_price * 0.005)
    
    if close_price >= open_price:
        high_price = max(open_price, close_price) + random.uniform(0, range_extension)
        low_price = min(open_price, close_price) - random.uniform(0, range_extension * 0.7)
    else:
        high_price = max(open_price, close_price) + random.uniform(0, range_extension * 0.7)
        low_price = min(open_price, close_price) - random.uniform(0, range_extension)
    
    return high_price, low_price

def create_historical_data():
    db = SessionLocal()
    try:
        stocks = db.query(Stock).all()
        print("과거 데이터 생성 시작...")
        
        end_time = datetime.now(tz=KST)
        start_time = end_time - timedelta(days=1)
        
        for stock in stocks:
            print(f"{stock.name} 과거 데이터 생성 중...")
            
            current_price = float(stock.previous_close)
            
            trend_data = get_stock_trend(stock.id)
            
            current_time = start_time
            while current_time < end_time:
                change_percent = generate_realistic_price_change(current_price, trend_data, float(stock.previous_close))
                new_price = current_price * (1 + change_percent)
                
                max_price = float(stock.previous_close) * 1.29
                min_price = float(stock.previous_close) * 0.71
                new_price = max(min_price, min(max_price, new_price))
                
                open_price = current_price
                close_price = new_price
                high_price, low_price = generate_realistic_ohlc(open_price, close_price)
                
                high_price = min(max_price, max(high_price, max(open_price, close_price)))
                low_price = max(min_price, min(low_price, min(open_price, close_price)))
                
                base_volume = random.randint(50000, 500000)
                volatility_multiplier = 1 + trend_data['volatility'] * 0.5
                momentum_multiplier = 1 + abs(change_percent) * 10
                volume = int(base_volume * volatility_multiplier * momentum_multiplier)
                volume = min(volume, 2000000)
                
                stock_price = StockPrice(
                    stock_id=stock.id,
                    open_price=Decimal(str(round(open_price, 0))),
                    high_price=Decimal(str(round(high_price, 0))),
                    low_price=Decimal(str(round(low_price, 0))),
                    close_price=Decimal(str(round(close_price, 0))),
                    volume=volume,
                    timestamp=current_time
                )
                db.add(stock_price)
                
                individual_ratio = random.uniform(0.3, 0.7)
                foreign_ratio = random.uniform(0.1, 0.3)
                individual_volume = int(volume * individual_ratio)
                foreign_volume = int(volume * foreign_ratio)
                institutional_volume = volume - individual_volume - foreign_volume
                
                volume_detail = VolumeDetail(
                    stock_id=stock.id,
                    individual_volume=individual_volume,
                    foreign_volume=foreign_volume,
                    institutional_volume=institutional_volume,
                    total_volume=volume,
                    timestamp=current_time
                )
                db.add(volume_detail)
                
                current_time += timedelta(minutes=5)
                current_price = close_price
                
                if random.random() < 0.01:
                    trend_data['trend'] = random.choice(['bullish', 'bearish', 'sideways'])
                    trend_data['momentum'] = random.uniform(0.3, 1.5)
                    trend_data['volatility'] = random.uniform(0.5, 2.5)
            
            stock.current_price = Decimal(str(round(current_price, 0)))
        
        db.commit()
        print("과거 데이터 생성 완료!")
        
    except Exception as e:
        print(f"과거 데이터 생성 오류: {e}")
        db.rollback()
    finally:
        db.close()

def update_stock_prices():
    db = SessionLocal()
    try:
        stocks = db.query(Stock).all()
        
        update_stock_trends()
        
        for stock in stocks:
            current_price = float(stock.current_price)
            previous_close = float(stock.previous_close)
            
            max_price = previous_close * 1.29
            min_price = previous_close * 0.71
            
            trend_data = get_stock_trend(stock.id)
            
            change_percent = generate_realistic_price_change(current_price, trend_data, previous_close)
            new_price = current_price * (1 + change_percent)
            
            new_price = max(min_price, min(max_price, new_price))
            
            open_price = current_price
            close_price = new_price
            
            high_price, low_price = generate_realistic_ohlc(open_price, close_price)
            
            high_price = min(max_price, max(high_price, max(open_price, close_price)))
            low_price = max(min_price, min(low_price, min(open_price, close_price)))
            
            base_volume = random.randint(50000, 500000)
            volatility_multiplier = 1 + trend_data['volatility'] * 0.5
            momentum_multiplier = 1 + abs(change_percent) * 10
            
            volume = int(base_volume * volatility_multiplier * momentum_multiplier)
            volume = min(volume, 2000000)
            
            individual_ratio = random.uniform(0.3, 0.7)
            foreign_ratio = random.uniform(0.1, 0.3)
            institutional_ratio = 1 - individual_ratio - foreign_ratio
            
            individual_volume = int(volume * individual_ratio)
            foreign_volume = int(volume * foreign_ratio)
            institutional_volume = volume - individual_volume - foreign_volume
            
            stock.current_price = Decimal(str(round(close_price, 0)))
            
            stock_price = StockPrice(
                stock_id=stock.id,
                open_price=Decimal(str(round(open_price, 0))),
                high_price=Decimal(str(round(high_price, 0))),
                low_price=Decimal(str(round(low_price, 0))),
                close_price=Decimal(str(round(close_price, 0))),
                volume=volume,
                timestamp=datetime.now(tz=KST)
            )
            db.add(stock_price)
            
            volume_detail = VolumeDetail(
                stock_id=stock.id,
                individual_volume=individual_volume,
                foreign_volume=foreign_volume,
                institutional_volume=institutional_volume,
                total_volume=volume,
                timestamp=datetime.now(tz=KST)
            )
            db.add(volume_detail)
        
        db.commit()
        print(f"주식 가격 업데이트 완료: {datetime.now(tz=KST)}")
        
    except Exception as e:
        print(f"주식 가격 업데이트 오류: {e}")
        db.rollback()
    finally:
        db.close()

def stock_simulator_worker():
    create_historical_data()
    while True:
        try:
            update_stock_prices()
            time.sleep(300)
        except Exception as e:
            print(f"주식 시뮬레이터 오류: {e}")

def start_stock_simulator():
    thread = threading.Thread(target=stock_simulator_worker, daemon=True)
    thread.start()
    print("주식 시뮬레이터가 시작되었습니다.")