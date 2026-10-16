FROM docker.io/library/caddy:2.11.7-builder-alpine@sha256:d6161a2c82fd58b3205048958fb6246d0c5d892beee8a47e90944610c4efd100 AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare@v0.2.4

FROM docker.io/library/caddy:2.11.7-alpine@sha256:d8542f48d34a9cf4e4c11a478865229840e87e4c96ea3f439101f31a5d35f75f

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s CMD wget --no-verbose --tries=1 --spider http://localhost:8888/health || exit 1
