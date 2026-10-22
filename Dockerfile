# Small official Node.js image based on Alpine Linux.
FROM node:24-alpine

WORKDIR /app

# Copy package files first so Docker can cache the npm install layer:
# it only re-runs when dependencies change, not on every code change.
COPY package*.json ./
RUN npm ci --omit=dev

COPY src ./src

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

# Don't run as root inside the container.
USER node

# Docker marks the container "unhealthy" if /health stops answering.
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/server.js"]
