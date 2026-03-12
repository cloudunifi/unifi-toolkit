# UniFi Toolkit

A cross-platform tool for remotely adopting and troubleshooting UniFi devices. Scans your local network for UniFi devices via UDP discovery, then performs actions over SSH.

## Features

- **Discover & Adopt** — Scan your subnet for UniFi devices and set their inform URL to point to your controller
- **Troubleshoot** — Pull device info, view logs, factory reset, or upgrade firmware on any UniFi device
- **Desktop App** (macOS) — Guided UI with Discover Devices and Troubleshoot flows
- **CLI** (all platforms) — Interactive TUI and non-interactive `--run` mode for scripting
- **Self-Update** — `--update` flag downloads and installs the latest version automatically

## Quick Install

### CLI (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/cloudunifi/unifi-toolkit/main/install.sh | sh
```

This detects your platform, downloads the correct binary, verifies its SHA256 checksum, and installs to `/usr/local/bin` (or `~/.local/bin` if not writable). You can override the install location:

```bash
INSTALL_DIR=/opt/bin curl -fsSL https://raw.githubusercontent.com/cloudunifi/unifi-toolkit/main/install.sh | sh
```

### macOS Desktop App

Download the DMG from the [Releases](https://github.com/cloudunifi/unifi-toolkit/releases) page, open it, and drag to Applications. The app is signed and notarized — just double-click to run. On first launch, grant **Local Network** access when prompted.

## Updating

```bash
unifi-toolkit --update
```

The CLI checks for updates in the background. When a newer version is available, `--version` shows a hint:

```
$ unifi-toolkit --version
unifi-toolkit v1.0.5 (update available: v1.0.6 — run --update to upgrade)
```

## Download

All binaries are available on the [Releases](https://github.com/cloudunifi/unifi-toolkit/releases) page.

| Platform | File |
|----------|------|
| macOS Desktop App (Apple Silicon) | `UniFi-Toolkit-x.x.x-mac-arm64.dmg` |
| macOS CLI (Apple Silicon) | `unifi-toolkit-macos-arm64` |
| macOS CLI (Intel) | `unifi-toolkit-macos-amd64` |
| Linux CLI (x86_64) | `unifi-toolkit-linux-amd64` |
| Linux CLI (ARM64) | `unifi-toolkit-linux-arm64` |
| Windows CLI (x86_64) | `unifi-toolkit-windows-amd64.exe` |

## Platform Notes

### macOS CLI
Both binaries are signed and notarized — run directly from Terminal.

### Linux
```bash
chmod +x unifi-toolkit-linux-amd64
./unifi-toolkit-linux-amd64
```
If device discovery fails, check your firewall rules (`sudo iptables -L -n | grep 10001`). If you have Docker or VPN interfaces, use `--subnet` to specify your LAN subnet explicitly.

### Windows
Download and run `unifi-toolkit-windows-amd64.exe`. On first run, Windows SmartScreen may show a warning. Click **More info > Run anyway** to proceed. This is a one-time prompt.

## CLI Usage

```bash
# Interactive TUI
unifi-toolkit

# Non-interactive adoption
unifi-toolkit --run -c 192.168.1.100 -s 192.168.1.0/24

# Device info
unifi-toolkit --run -A info -t 192.168.1.20

# Pull device logs
unifi-toolkit --run -A logs -t 192.168.1.20

# Factory reset
unifi-toolkit --run -A reset -t 192.168.1.20 --yes

# Firmware upgrade
unifi-toolkit --run -A firmware -t 192.168.1.20 --firmware-url https://dl.ui.com/.../firmware.bin --yes

# Set inform URL on a specific device
unifi-toolkit --run -A set-inform -c unifi.mysite.com -t 192.168.1.20

# Update to latest version
unifi-toolkit --update
```

Run `unifi-toolkit --help` for all options.

---

Provided by [Cloud UniFi](https://www.cloudunifi.com)
