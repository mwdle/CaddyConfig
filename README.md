# Caddy Configuration

This repository builds and runs Caddy as a rootless Podman Quadlet.

Rootless publishing on ports 80 and 443 requires
`net.ipv4.ip_unprivileged_port_start` to be 80 or lower on the host.

## Podman secrets

Create these secrets as the rootless Quadlet user:

```text
caddy_email
caddy_cloudflare_api_token
```

For example:

```console
podman secret create caddy_email -
podman secret create caddy_cloudflare_api_token -
```

## Deployment

```console
mkdir -p ~/.config/containers/systemd
ln -sfnT "$PWD" ~/.config/containers/systemd/CaddyConfig
ln -sfnT "$(realpath ../podman-networks)" ~/.config/containers/systemd/podman-networks
systemctl --user daemon-reload
systemctl --user start caddy.service
```

Rebuild after changing the Containerfile inputs:

```console
systemctl --user restart caddy-build.service
systemctl --user restart caddy.service
```

The Quadlet currently joins only the Podman networks that exist. Add each
service network to `caddy.container` as that service is migrated.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
