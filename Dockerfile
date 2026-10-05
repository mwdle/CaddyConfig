FROM caddy:2.11.4-builder-alpine@sha256:0aa610043dab5da82ad0a0268e46bb852785e6f5160f12f1c6fe3f42903d7e1b AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare@v0.2.4

FROM caddy:2.11.4-alpine@sha256:de23def33b17fb5d1290b0f6c2add1d70780e52341896c00a4c8a2a2fe9d355e

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

USER caddy

HEALTHCHECK --interval=1m --timeout=5s --retries=3 --start-period=30s CMD wget --no-verbose --tries=1 --spider http://localhost:8888/health || exit 1