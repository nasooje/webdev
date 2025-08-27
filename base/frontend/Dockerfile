FROM node@sha256:c6ae79e38498325db67193d391e6ec1d224d96c693a8a4d943498556716d3783

RUN apt-get update && apt-get install -y \
    fontconfig \
    fonts-dejavu-core \
    && fc-cache -f \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY . .

COPY package*.json ./
RUN npm install

RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

EXPOSE 3000

CMD ["npm", "start"] 