# UxPlay OpenWrt Package

OpenWrt package for UxPlay - AirPlay Mirror and Audio server.

## Features

- AirPlay 2 mirroring and audio streaming
- Supports iOS/iPadOS/macOS devices
- Pre-built packages for 10+ architectures
- Automated CI/CD with GitHub Actions

## Quick Installation

Download the `.ipk` for your architecture from [Releases](../../releases).

Install on your OpenWrt device:

```bash
scp uxplay_*.ipk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'opkg install /tmp/uxplay_*.ipk'
```

Run UxPlay:

```bash
uxplay
```

## Supported Architectures

- x86_64, x86 (32-bit)
- ARM Systemready (armv7, armv8)
- Raspberry Pi (4/5, 3, 2, Zero/Zero W)
- MediaTek routers (MT7621, MT7622, MT7623, MT7629)
- Qualcomm IPQ807x

## Building from Source

### Using GitHub Actions (Recommended)

Push to GitHub or create a tag to trigger automated builds:

```bash
git tag v1.73
git push origin v1.73
```

Artifacts will be available in Actions tab or as a Release.

### Local Build

Requires OpenWrt SDK for your target architecture.

```bash
./build.sh /path/to/openwrt-sdk
```

The compiled `.ipk` will be in the SDK's `bin/packages/` directory.

## Usage

Basic usage:

```bash
uxplay
```

Common options:

```bash
uxplay -n "My AirPlay Server"  # Custom name
uxplay -p 7000                 # Custom port
uxplay -vs kmssink             # Video sink
uxplay -as alsasink            # Audio sink
```

Full documentation: `uxplay -h`

## Troubleshooting

**Dependencies missing:**
```bash
opkg update
opkg install libplist libopenssl libdbus mdnsresponder libgstreamer1 gstreamer1-plugins-base
```

**Check if running:**
```bash
ps | grep uxplay
netstat -tlnp | grep 7000
```

**Logs:**
Run in foreground to see output: `uxplay -d`

## Project Structure

- `Makefile` - OpenWrt package definition
- `build.sh` - Local build helper script
- `.github/workflows/build.yml` - CI/CD automation

## License

GPL-3.0 (same as UxPlay upstream)

## Credits

- UxPlay: https://github.com/FDH2/UxPlay
- OpenWrt: https://openwrt.org
