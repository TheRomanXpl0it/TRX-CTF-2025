FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npx drizzle-kit push --force
RUN npm run check
RUN npm run build
RUN npm prune --omit=dev

FROM node:22-alpine
WORKDIR /app
COPY --from=builder /app/build build/
COPY --from=builder /app/node_modules node_modules/
COPY --from=builder /app/local.db .
COPY package.json .
EXPOSE 1337
ENV NODE_ENV=production

ENV PORT=1337

CMD [ "node", "build" ]
