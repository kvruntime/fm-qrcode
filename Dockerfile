FROM node:21-alpine as build
WORKDIR /usr/app
RUN --mount=type=bind,source=package.json,target=package.json \
  --mount=type=bind,source=package-lock.json,target=package-lock.json \
  --mount=type=cache,target=/root/.npm \
  npm ci
COPY . .
ENV NODE_ENV=Development
RUN  npm run build

FROM nginx:alpine as deploy
WORKDIR /usr/share/nginx/html
COPY --from=build /usr/app/dist .
