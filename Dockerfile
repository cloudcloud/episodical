FROM node:slim AS fe
WORKDIR /app

COPY *.js* yarn.lock public src .
RUN yarn && NODE_OPTIONS=--openssl-legacy-provider yarn build

FROM golang:alpine AS be

WORKDIR /fo
COPY cmd pkg go.* .
COPY --from=fe ["/app/pkg/server/dist/", "pkg/server/dist/"]
RUN apk add --no-cache git && \
    go build ./cmd/file-organization

FROM golang:alpine AS release
ENTRYPOINT ["/file-organization"]
COPY --from=be ["/fo/file-organization", "/file-organization"]

