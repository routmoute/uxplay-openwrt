include $(TOPDIR)/rules.mk

PKG_NAME:=uxplay
PKG_VERSION:=master
PKG_RELEASE:=1

# Logique pour déterminer la source
ifeq ($(findstring v,$(PKG_VERSION)),v)
  # C'est un tag (v1.72.2, v1.73, etc.)
  PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
  PKG_SOURCE_URL:=https://github.com/FDH2/UxPlay/archive/refs/tags/$(PKG_VERSION).tar.gz
  PKG_HASH:=skip
  PKG_BUILD_DIR:=$(BUILD_DIR)/UxPlay-$(PKG_VERSION)
else
  # C'est master (ou autre branche)
  PKG_SOURCE_PROTO:=git
  PKG_SOURCE_URL:=https://github.com/FDH2/UxPlay.git
  PKG_SOURCE_VERSION:=$(PKG_VERSION)
  # Quand on clone depuis git, OpenWrt crée: ${PKG_NAME}-${PKG_SOURCE_VERSION}
  PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_SOURCE_VERSION)
endif

PKG_INSTALL:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=OpenWrt

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/uxplay
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=AirPlay Mirror and Audio server
  URL:=https://github.com/FDH2/UxPlay
  DEPENDS:=+libplist +libopenssl +libavahi-compat-libdnssd +libgstreamer1 \
	+gstreamer1-plugins-base +gstreamer1-plugins-good +gstreamer1-plugins-bad
  MENU:=1
endef

define Package/uxplay/description
  UxPlay is an AirPlay Mirror and AirPlay Audio server for Linux, macOS, and BSD.
  It allows your Apple devices to stream audio and video to a Linux system
  running UxPlay, similar to how they can stream to an Apple TV.
endef

define Package/uxplay/config
  source "$(SOURCE)/Config.in"
endef

CMAKE_OPTIONS += \
	-DNO_MARCH_NATIVE=ON \
	-DCMAKE_BUILD_TYPE=Release

define Package/uxplay/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/uxplay $(1)/usr/bin/
	
	$(INSTALL_DIR) $(1)/usr/share/man/man1
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/uxplay.1 $(1)/usr/share/man/man1/
	
	$(INSTALL_DIR) $(1)/etc/systemd/user
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/uxplay.service $(1)/etc/systemd/user/
	
	$(INSTALL_DIR) $(1)/usr/share/doc/uxplay
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/README.md $(1)/usr/share/doc/uxplay/
endef

$(eval $(call BuildPackage,uxplay))
