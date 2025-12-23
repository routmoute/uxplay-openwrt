# UxPlay OpenWrt Bundle

OpenWrt package for AirPlay 2 server (UxPlay).

## Quick Start

### Local Build

Requires OpenWrt SDK.

```bash
./build.sh /path/to/openwrt-sdk-*
```

The compiled `.ipk` will be in `bin/` directory.

### GitHub Actions

Push to GitHub and workflows automatically compile for 10 architectures:
- x86_64, x86
- ARM Systemready (armv7, armv8)
- Raspberry Pi (4, 3, 2, Zero/Zero W)
- MediaTek (MT7621, MT7622, MT7623, MT7629)
- Qualcomm IPQ807x

**Tags trigger releases** with compiled packages:

```bash
git tag v1.73
git push origin v1.73
```

## Installation

Copy `.ipk` to your device:

```bash
scp uxplay_1.73_*_*.ipk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'opkg install /tmp/uxplay_1.73_*_*.ipk'
```

Enable and start service:

```bash
uci set uxplay.@general[0].enabled=1
uci commit uxplay
/etc/init.d/uxplay start
```

## Configuration

Edit via UCI:

```bash
uci set uxplay.@general[0].name="My Device"
uci set uxplay.@general[0].port=6000
uci commit uxplay
/etc/init.d/uxplay restart
```

Full config in `/etc/config/uxplay`.

## Troubleshooting

### Service won't start
- Check logs: `/var/log/uxplay.log`
- Verify dependencies: `opkg list-installed | grep gstreamer`
- Check port: `netstat -tlnp | grep 6000`

### Audio/Video issues
- Ensure GStreamer plugins installed: `opkg install gstreamer1-plugins-{base,good,bad}`
- Check hardware acceleration support for your platform

### Build fails
- Update SDK: `./build.sh /path/to/sdk && make distclean`
- Check `Config.in` dependencies are available

## Files

- `Makefile` - OpenWrt package definition
- `Config.in` - Configuration options
- `build.sh` - Local build helper
- `files/` - Init script, config template, install hook
- `.github/workflows/` - GitHub Actions CI/CD

## License

Same as UxPlay (LGPL 2.1+).
