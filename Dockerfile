FROM caddy:2.11.4-builder-alpine@sha256:1a1689db91cfb390b2d856a1b3774e796852822cd723fa54c475b272f82bb4b7 AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare@v0.2.4

FROM caddy:2.11.4-alpine@sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

USER caddy

HEALTHCHECK --interval=1m --timeout=5s --retries=3 --start-period=30s CMD wget --no-verbose --tries=1 --spider http://localhost:8888/health || exit 1