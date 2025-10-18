FROM node:18-alpine
WORKDIR /app

COPY app-dir/package*.json ./
RUN npm ci

COPY app-dir/. .
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]


