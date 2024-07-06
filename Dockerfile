FROM node:slim AS fe
WORKDIR /app
COPY *.j* index.html yarn.lock .yarnrc.yml ./
COPY src ./src/
COPY .yarn ./.yarn/
RUN corepack enable && \
  yarn set version 4.3.1 && \
  yarn install && \
  yarn build

FROM golang:alpine AS be
WORKDIR /ep
COPY cmd ./cmd/
COPY pkg ./pkg/
COPY go.* ./
COPY --from=fe ["/app/pkg/server/dist/", "pkg/server/dist/"]
RUN apk add --no-cache git && \
    go build ./cmd/episodical

FROM golang:alpine AS release
ENTRYPOINT ["/episodical"]
COPY --from=be ["/ep/episodical", "/episodical"]

