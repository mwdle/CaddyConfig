FROM caddy:2.11.2-builder-alpine@sha256:ff7dd52d7a2b46429367617bbde8812b5e7c567139a0d713607e6122d9dc62c4 AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare@v0.2.4

FROM caddy:2.11.2-alpine@sha256:24d58e24e4231c6667677a39469a3d843a3222eadbf640f22933f24bed0939ec

COPY --from=builder /usr/bin/caddy /usr/bin/caddy