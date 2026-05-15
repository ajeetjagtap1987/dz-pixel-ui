# syntax=docker/dockerfile:1.6

# Static UI served by Nginx.
# In a real build, you'd have a Node build stage first:
#   FROM node:20-alpine AS build
#   WORKDIR /app
#   COPY package*.json ./
#   RUN npm ci
#   COPY . .
#   RUN npm run build
# Then copy /app/dist into nginx html dir.

FROM nginx:alpine

# Copy our static HTML (replace with your React build output)
COPY index.html /usr/share/nginx/html/index.html

# Custom config with /api/* proxy + /healthz
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Use envsubst at runtime to inject DASHBOARD_URL
ENV DASHBOARD_URL=http://localhost:8081

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
    CMD wget -qO- http://localhost:8080/healthz || exit 1

# Render template, then start nginx
CMD ["sh", "-c", "envsubst '${DASHBOARD_URL}' < /etc/nginx/templates/default.conf.template > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"]
