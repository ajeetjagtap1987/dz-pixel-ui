# dz-pixel-ui

Static UI served by Nginx. Calls `dz-pixel-dashboard` for live data.

This is a **placeholder static page** — replace `index.html` with your real React/Tailwind build output (typically `dist/` or `build/`).

## When you have a real React app

Update the Dockerfile to:

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/templates/default.conf.template
ENV DASHBOARD_URL=http://dashboard-svc:8080
EXPOSE 8080
CMD ["sh", "-c", "envsubst '${DASHBOARD_URL}' < /etc/nginx/templates/default.conf.template > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]
```

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `DASHBOARD_URL` | `http://localhost:8081` | Full URL of dashboard-svc (used by Nginx for `/api/*` proxy) |

## Endpoints (served by Nginx)

- `/` — React SPA
- `/api/*` — proxied to `$DASHBOARD_URL`
- `/healthz` — 200 OK for ECS health check
