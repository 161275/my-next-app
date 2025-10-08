FROM node:18-alpine
WORKDIR /app

# ENV NODE_ENV=production

# Copy only what's needed
COPY package*.json ./
# COPY node_modules ./node_modules
RUN npm ci
# COPY . .
# RUN npm run build
COPY .next .


EXPOSE 3000

CMD ["npm", "start"]