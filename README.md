# Homelab

Self-hosted services running on a Lenovo ThinkCentre M920q.

## Hardware
- Intel i5-8400T (6 cores, Quick Sync)
- 8 GB RAM
- 240 GB SSD
- Network: Wi-Fi + Tailscale for remote access

## Stack
- **OS:** Debian 13 (trixie)
- **Containers:** Docker + Docker Compose
- **Remote access:** Tailscale, SSH (key-only, root login disabled)

## Services
| Service    | Purpose                         | Port |
|------------|---------------------------------|------|
| Technitium | DNS server + network ad blocking | 53, 5380 |
| Jellyfin   | Media server (Intel QSV hardware transcoding) | 8096 |

## Layout
Each service lives in its own folder with a `compose.yaml`.
Runtime data (`config/`, `cache/`) is excluded from Git.
