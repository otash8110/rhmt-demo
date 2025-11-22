# ---------------------------
# 1) Build stage
# ---------------------------
FROM node:lts-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build:prod


# ---------------------------
# 2) Production stage
# ---------------------------
FROM node:lts-alpine

# Install static file server
RUN npm install -g http-server

WORKDIR /app

# Copy only the built files
COPY --from=build /app/dist ./dist

EXPOSE 8080

CMD [ "http-server", "dist", "-p", "8080", "-s", "-c-1" ]
