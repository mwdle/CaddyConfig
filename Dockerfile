FROM caddy:2.11.2-builder-alpine@sha256:e434a521b6ab210a190688e977350dbba8afe974b0083ab8d0a8e6555dacc738 AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare@v0.2.4

FROM caddy:2.11.2-alpine@sha256:fce4f15aad23222c0ac78a1220adf63bae7b94355d5ea28eee53910624acedfa

COPY --from=builder /usr/bin/caddy /usr/bin/caddy