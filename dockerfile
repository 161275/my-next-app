# FROM node:18-alpine
# WORKDIR /app

# COPY package*.json ./
# RUN npm ci

# COPY . .
# RUN npm run build

# EXPOSE 3000

# CMD ["npm", "start"]

# ---- 1. Build Stage ----
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---- 2. Production Stage ----
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Copy only what's needed
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package*.json ./

EXPOSE 3000

CMD ["npm", "start"]
