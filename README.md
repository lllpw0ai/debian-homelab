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
- **Updates:** unattended-upgrades (automatic Debian security patches)

## Services
| Service    | Purpose                         | Port |
|------------|---------------------------------|------|
| Technitium | DNS server + network ad blocking | 53, 5380 |
| Jellyfin   | Media server (Intel QSV hardware transcoding) | 8096 |
| Uptime Kuma | Service monitoring + phone alerts (ntfy) | 3001 |

## Layout
Each service lives in its own folder with a `compose.yaml`.
Runtime data (`config/`, `cache/`) is excluded from Git.

## Backups
Nightly encrypted, deduplicated backups with **restic** to Google Drive (via rclone),
scheduled by a **systemd timer** (`scripts/homelab-backup.timer`).
Containers are stopped during the backup for consistent databases; Technitium stays up so DNS never drops.
Retention: 7 daily, 4 weekly, 6 monthly. Failures alert to my phone via ntfy.
Restores are tested.

## Network notes
- The ISP gateway (Cox Panoramic) does not allow custom DNS servers or disabling DHCP.
  Instead, Technitium is pushed to every Tailscale device as its DNS server
  (Tailscale "Override DNS servers"), so ad blocking works at home and away.
- The server is Wi-Fi only; Wi-Fi power saving is disabled to prevent dropouts.
