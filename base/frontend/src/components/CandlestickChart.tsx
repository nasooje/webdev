import React, { useState, useEffect } from 'react';
import { ComposedChart, Tooltip, ResponsiveContainer } from 'recharts';

interface CandlestickData {
  timestamp: string;
  open: number;
  high: number;
  low: number;
  close: number;
  volume: number;
}

interface CandlestickChartProps {
  data: CandlestickData[];
  height?: number;
  width?: number;
}

const createLinearScale = (domain: [number, number], range: [number, number]) => {
  const [domainMin, domainMax] = domain;
  const [rangeMin, rangeMax] = range;
  const domainSpan = domainMax - domainMin;
  const rangeSpan = rangeMax - rangeMin;
  
  return (value: number) => {
    if (domainSpan === 0) return rangeMin;
    return rangeMin + ((value - domainMin) / domainSpan) * rangeSpan;
  };
};

const KoreanCandlestickChart: React.FC<{
  data: CandlestickData[];
  width: number;
  height: number;
}> = ({ data: originalData, width, height }) => {
  const MAX_CANDLES = 200;
  const data = originalData.slice(-MAX_CANDLES);
  const headerHeight = 50;
  const chartHeight = height * 0.7;
  const volumeHeight = height * 0.2;
  const bottomMargin = height * 0.1;
  
  const margin = { top: 20, right: 100, bottom: 80, left: 60 };
  const chartWidth = Math.max(width - margin.left - margin.right, 300);
  
  const candleChartHeight = chartHeight - headerHeight - margin.top;
  const volumeChartHeight = volumeHeight;
  
  const svgWidth = chartWidth + margin.left + margin.right;
  const svgHeight = height + 40;

  if (!data || data.length === 0) {
    return (
      <div style={{
        width: '100%',
        height: height,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: '#ffffff',
        border: '1px solid #e0e6ed',
        borderRadius: '8px',
        color: '#666',
        fontSize: '14px'
      }}>
        차트 데이터를 불러오는 중...
      </div>
    );
  }

  const prices = data.flatMap(d => [d.high, d.low]);
  const minPrice = Math.min(...prices);
  const maxPrice = Math.max(...prices);
  const priceRange = maxPrice - minPrice;
  const padding = priceRange * 0.05;

  const adjustedMin = minPrice - padding;
  const adjustedMax = maxPrice + padding;

  const maxVolume = Math.max(...data.map(d => d.volume));

  const priceScale = (price: number) => {
    return margin.top + headerHeight + ((adjustedMax - price) / (adjustedMax - adjustedMin)) * candleChartHeight;
  };

  const volumeScale = (volume: number) => {
    return chartHeight + ((maxVolume - volume) / maxVolume) * volumeChartHeight;
  };

  const candleSpacing = chartWidth / data.length;
  const candleWidth = Math.min(Math.max(candleSpacing * 0.8, 3), 20);

  const currentPrice = data.length > 0 ? data[data.length - 1].close : 0;
  const previousPrice = data.length > 1 ? data[data.length - 2].close : currentPrice;
  const isMarketUp = currentPrice >= previousPrice;

  const yTicks = 8;
  const yTickValues = [];
  for (let i = 0; i < yTicks; i++) {
    yTickValues.push(adjustedMax - (i * (adjustedMax - adjustedMin) / (yTicks - 1)));
  }

  const xTickIndices: number[] = [];

  return (
    <div style={{ 
      width: '100%', 
      height: svgHeight,
      background: '#ffffff',
      border: '1px solid #e0e6ed',
      borderRadius: '8px',
      overflow: 'visible'
    }}>
      {}
      <div style={{
        padding: '12px 20px',
        background: '#f8f9fa',
        borderBottom: '1px solid #e0e6ed',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: `${headerHeight - 2}px`
      }}>
        <div>
          <span style={{ 
            fontSize: '16px', 
            fontWeight: 'bold', 
            color: '#2c3e50' 
          }}>
            캔들차트
          </span>
          <span style={{ 
            fontSize: '12px', 
            color: '#7f8c8d',
            marginLeft: '10px'
          }}>
          </span>
        </div>
        <div style={{ 
          fontSize: '14px', 
          fontWeight: 'bold',
          color: isMarketUp ? '#d73027' : '#1a73e8'
        }}>
          {currentPrice.toLocaleString()}원
        </div>
      </div>

      <div style={{ 
        width: '100%', 
        height: `${svgHeight - headerHeight}px`,
        overflow: 'visible'
      }}>
        <svg width="100%" height={svgHeight - headerHeight} viewBox={`0 0 ${svgWidth} ${svgHeight - headerHeight}`}>
          {}
          <rect 
            x={margin.left} 
            y={margin.top} 
            width={chartWidth} 
            height={candleChartHeight} 
            fill="#ffffff" 
            stroke="#e0e6ed" 
            strokeWidth={1}
          />

          {}
          {yTickValues.map((price, index) => {
            const y = margin.top + ((adjustedMax - price) / (adjustedMax - adjustedMin)) * candleChartHeight;
            return (
              <g key={`y-tick-${index}`}>
                <line
                  x1={margin.left}
                  x2={margin.left + chartWidth}
                  y1={y}
                  y2={y}
                  stroke="#f0f2f5"
                  strokeWidth={1}
                  strokeDasharray="1,1"
                />
                <text
                  x={margin.left + chartWidth + 5}
                  y={y + 4}
                  fontSize="11"
                  fill="#666666"
                  fontFamily="Arial, sans-serif"
                >
                  {Math.round(price).toLocaleString()}
                </text>
              </g>
            );
          })}

          {}
          {}
          {xTickIndices.map((dataIndex, index) => {
            if (dataIndex >= data.length) return null;
            const x = margin.left + dataIndex * candleSpacing;
            const timeStr = new Date(data[dataIndex].timestamp).toLocaleTimeString('ko-KR', {
              hour: '2-digit',
              minute: '2-digit'
            });
            
            return (
              <g key={`x-tick-${index}`}>
                <line
                  x1={x}
                  x2={x}
                  y1={margin.top}
                  y2={margin.top + candleChartHeight}
                  stroke="#f0f2f5"
                  strokeWidth={1}
                  strokeDasharray="1,1"
                />
                <text
                  x={x}
                  y={margin.top + candleChartHeight + 20}
                  textAnchor="middle"
                  fontSize="10"
                  fill="#666666"
                  fontFamily="Arial, sans-serif"
                >
                  {timeStr}
                </text>
              </g>
            );
          })}

          {}
          {data.map((candle, index) => {
            const x = margin.left + index * candleSpacing;
            const isRising = candle.close >= candle.open;
            
            const candleColor = isRising ? '#d73027' : '#1a73e8';
            const fillColor = isRising ? '#d73027' : '#1a73e8';
            
            const openY = margin.top + ((adjustedMax - candle.open) / (adjustedMax - adjustedMin)) * candleChartHeight;
            const closeY = margin.top + ((adjustedMax - candle.close) / (adjustedMax - adjustedMin)) * candleChartHeight;
            const highY = margin.top + ((adjustedMax - candle.high) / (adjustedMax - adjustedMin)) * candleChartHeight;
            const lowY = margin.top + ((adjustedMax - candle.low) / (adjustedMax - adjustedMin)) * candleChartHeight;
            
            const bodyTop = Math.min(openY, closeY);
            const bodyHeight = Math.max(Math.abs(closeY - openY), 1);
            
            const wickX = x + candleSpacing / 2;
            
            return (
              <g key={`candle-${index}`}>
                {}
                <line
                  x1={wickX}
                  y1={highY}
                  x2={wickX}
                  y2={bodyTop}
                  stroke={candleColor}
                  strokeWidth={1}
                />
                
                {}
                <line
                  x1={wickX}
                  y1={bodyTop + bodyHeight}
                  x2={wickX}
                  y2={lowY}
                  stroke={candleColor}
                  strokeWidth={1}
                />
                
                {}
                <rect
                  x={x + (candleSpacing - candleWidth) / 2}
                  y={bodyTop}
                  width={candleWidth}
                  height={bodyHeight}
                  fill={fillColor}
                  stroke={candleColor}
                  strokeWidth={1}
                />
              </g>
            );
          })}

          {}
          <line
            x1={margin.left}
            x2={margin.left + chartWidth}
            y1={margin.top + ((adjustedMax - currentPrice) / (adjustedMax - adjustedMin)) * candleChartHeight}
            y2={margin.top + ((adjustedMax - currentPrice) / (adjustedMax - adjustedMin)) * candleChartHeight}
            stroke={isMarketUp ? '#d73027' : '#1a73e8'}
            strokeWidth={2}
            strokeDasharray="3,3"
            opacity={0.8}
          />

          {}
          <rect 
            x={margin.left} 
            y={chartHeight} 
            width={chartWidth} 
            height={volumeChartHeight} 
            fill="#ffffff" 
            stroke="#e0e6ed" 
            strokeWidth={1}
          />

          {}
          {data.map((candle, index) => {
            const x = margin.left + index * candleSpacing;
            const barHeight = (candle.volume / maxVolume) * volumeChartHeight;
            const isRising = candle.close >= candle.open;
            const volumeColor = isRising ? '#d7302780' : '#1a73e880';
            
            return (
              <rect
                key={`volume-${index}`}
                x={x + (candleSpacing - candleWidth) / 2}
                y={chartHeight + volumeChartHeight - barHeight}
                width={candleWidth}
                height={barHeight}
                fill={volumeColor}
              />
            );
          })}

          {}
          <text
            x={margin.left + chartWidth + 5}
            y={chartHeight + 15}
            fontSize="10"
            fill="#666666"
            fontFamily="Arial, sans-serif"
          >
            {(maxVolume / 1000000).toFixed(1)}M
          </text>
          <text
            x={margin.left + chartWidth + 5}
            y={chartHeight + volumeChartHeight}
            fontSize="10"
            fill="#666666"
            fontFamily="Arial, sans-serif"
          >
            0
          </text>
        </svg>
      </div>
    </div>
  );
};

const CandlestickChart: React.FC<CandlestickChartProps> = ({ 
  data, 
  height = 600,
  width 
}) => {
  const [containerWidth, setContainerWidth] = React.useState(1000);
  const containerRef = React.useRef<HTMLDivElement>(null);

  React.useEffect(() => {
    const updateWidth = () => {
      if (containerRef.current && !width) {
        const availableWidth = containerRef.current.offsetWidth;
        setContainerWidth(Math.max(availableWidth - 5, 800));
      }
    };

    updateWidth();
    window.addEventListener('resize', updateWidth);
    
    const timeoutId = setTimeout(updateWidth, 100);
    
    return () => {
      window.removeEventListener('resize', updateWidth);
      clearTimeout(timeoutId);
    };
  }, [width]);

  const chartWidth = width || containerWidth;

  return (
    <div 
      ref={containerRef}
      style={{ 
        width: '100%',
        minHeight: `${height + 50}px`,
        fontFamily: '"Noto Sans KR", sans-serif',
        position: 'relative',
        overflow: 'visible'
      }}
    >
      <KoreanCandlestickChart 
        data={data}
        width={chartWidth}
        height={height}
      />
    </div>
  );
};

export default CandlestickChart; 