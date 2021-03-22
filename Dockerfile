FROM node:14.16.0-alpine AS development

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install --production=false

COPY . .

RUN yarn build

FROM node:14.16.0-alpine AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install --production

COPY . .

COPY --from=development /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]
