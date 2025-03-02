FROM node:18-alpine as builder

WORKDIR /client
COPY client/package.json client/package-lock.json ./
RUN npm ci

WORKDIR /server
COPY server/package.json server/package-lock.json ./
RUN npm install aria2
RUN npm ci

WORKDIR /client
COPY client .
RUN npm run build

WORKDIR /server
COPY server .
RUN npm run build

RUN mv /server/dist /dist && \
    mv /client/dist /dist/client

FROM node:18-alpine

COPY --from=builder /dist /mediathekviewweb

CMD [ "node", "/mediathekviewweb/app.js" ]
