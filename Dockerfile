FROM --platform=$BUILDPLATFORM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:stable-alpine AS client

EXPOSE 80

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

COPY nginx.fastcgi.conf /etc/nginx/templates/fastcgi.conf
COPY nginx.http.conf /etc/nginx/templates/http.conf
COPY --from=builder /app/dist /app

ENTRYPOINT ["/entry.sh"]
