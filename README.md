# UniFi Toolkit

A cross-platform tool for remotely adopting and troubleshooting UniFi devices. Scans your local network for UniFi devices via UDP discovery, then performs actions over SSH.

## Features

- **Discover & Adopt** — Scan your subnet for UniFi devices and set their inform URL to point to your controller
- **Troubleshoot** — Pull device info, view logs, factory reset, or upgrade firmware on any UniFi device
- **Desktop App** (macOS) — Guided UI with Discover Devices and Troubleshoot flows
- **CLI** (all platforms) — Interactive TUI and non-interactive `--run` mode for scripting

## Download

Download the latest release from the [Releases](https://github.com/cloudunifi/unifi-toolkit/releases) page.

| Platform | File |
|----------|------|
| macOS Desktop App (Apple Silicon) | `UniFi-Adopt-x.x.x-mac-arm64.dmg` |
| macOS CLI (Apple Silicon) | `unifi-adopt-macos-arm64` |
| macOS CLI (Intel) | `unifi-adopt-macos-amd64` |
| Linux CLI (x86_64) | `unifi-adopt-linux-amd64` |
| Linux CLI (ARM64) | `unifi-adopt-linux-arm64` |
| Windows CLI (x86_64) | `unifi-adopt-windows-amd64.exe` |

## Installation

### macOS Desktop App
Download the DMG, open it, and drag to Applications. The app is signed and notarized by Apple — just double-click to run. On first launch, grant **Local Network** access when prompted. If no prompt appears, enable in **System Settings > Privacy & Security > Local Network** and restart the app.

### macOS CLI
Download the binary for your architecture. Both are signed and notarized — run directly from Terminal.

### Linux
```bash
chmod +x unifi-adopt-linux-amd64
./unifi-adopt-linux-amd64
```
If device discovery fails, check your firewall rules (`sudo iptables -L -n | grep 10001`). If you have Docker or VPN interfaces, use `--subnet` to specify your LAN subnet explicitly.

### Windows
Download and run `unifi-adopt-windows-amd64.exe`. On first run, Windows SmartScreen may show a warning. Click **More info > Run anyway** to proceed. This is a one-time prompt.

If your firewall blocks device discovery, try running as Administrator.

## CLI Usage

```bash
# Interactive TUI
./unifi-adopt

# Non-interactive adoption
./unifi-adopt --run --subnet 192.168.1.0/24 --controller 192.168.1.100 --port 8080

# Non-interactive troubleshooting
./unifi-adopt --run --troubleshoot --subnet 192.168.1.0/24
```

Run `./unifi-adopt --help` for all options.

---

Provided by [Cloud UniFi](https://www.cloudunifi.com)
