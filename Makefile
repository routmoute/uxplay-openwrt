include $(TOPDIR)/rules.mk

PKG_NAME:=uxplay
PKG_VERSION:=master
PKG_RELEASE:=1

# Si PKG_VERSION contient "v" (ex: v1.72.2), utiliser le tag
# Sinon (master ou autre branche), utiliser git
ifeq ($(findstring v,$(PKG_VERSION)),v)
  PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
  PKG_SOURCE_URL:=https://github.com/FDH2/UxPlay/archive/refs/tags/$(PKG_VERSION).tar.gz
  PKG_HASH:=skip
  PKG_BUILD_DIR:=$(BUILD_DIR)/UxPlay-$(subst v,,$(PKG_VERSION))
else
  PKG_SOURCE_PROTO:=git
  PKG_SOURCE_URL:=https://github.com/FDH2/UxPlay.git
  PKG_SOURCE_VERSION:=$(PKG_VERSION)
  PKG_MIRROR_HASH:=skip
  PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
endif

PKG_INSTALL:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=OpenWrt

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# Tell CMake where to find staging directory for dependencies
CMAKE_OPTIONS += \
	-DCMAKE_PREFIX_PATH=$(STAGING_DIR)/usr

define Package/uxplay
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=AirPlay Mirror and Audio server
  URL:=https://github.com/FDH2/UxPlay
  DEPENDS:=+libstdcpp +libplist +libopenssl +avahi-dbus-daemon +libavahi-compat-libdns_sd
endef

define Package/uxplay/description
  UxPlay is an AirPlay Mirror and AirPlay Audio server for Linux, macOS, and BSD.
  It allows your Apple devices to stream audio and video to a Linux system
  running UxPlay, similar to how they can stream to an Apple TV.
  
  Note: This minimal build excludes GStreamer. Audio/video rendering requires
  GStreamer plugins to be installed separately.
endef

CMAKE_OPTIONS += \
	-DNO_MARCH_NATIVE=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DWITH_SYSTEMD=OFF \
	-DNO_X11_DEPS=ON \
	-DOPENSSL_ROOT_DIR=$(STAGING_DIR)/usr \
	-DOPENSSL_INCLUDE_DIR=$(STAGING_DIR)/usr/include \
	-DOPENSSL_CRYPTO_LIBRARY=$(STAGING_DIR)/usr/lib/libcrypto.so \
	-DOPENSSL_SSL_LIBRARY=$(STAGING_DIR)/usr/lib/libssl.so \
	-Ddns_sd_INCLUDE_DIR=$(STAGING_DIR)/usr/include \
	-Ddns_sd_LIBRARY=$(STAGING_DIR)/usr/lib/libdns_sd.so \
	-DDNSSD=$(STAGING_DIR)/usr/lib/libdns_sd.so \
	-DDNSSD_INCLUDE_DIR=$(STAGING_DIR)/usr/include

define Package/uxplay/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/uxplay $(1)/usr/bin/
endef

$(eval $(call BuildPackage,uxplay))
