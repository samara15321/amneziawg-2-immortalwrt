# This is free software, licensed under the MIT License.

include $(TOPDIR)/rules.mk

PKG_NAME:=amneziawg-go
PKG_VERSION:=1.0.20250813
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/amnezia-vpn/amneziawg-go.git
PKG_SOURCE_VERSION:=15d7259cd45f41d50bc5838dc002698362f29a2d

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/amnezia-vpn/amneziawg-go

include $(INCLUDE_DIR)/package.mk
include ../../packages/lang/golang/golang-package.mk

define Package/amneziawg-go
  SECTION:=net
  CATEGORY:=Network
  TITLE:=AmneziaWG userspace implementation program (written in Go)
  DEPENDS:=$(GO_ARCH_DEPENDS) +kmod-tun
endef

define Package/amneziawg-go/description
  AmneziaWG is a contemporary version of the WireGuard protocol. It's a fork of
  WireGuard-Go and offers protection against detection by Deep Packet Inspection
  (DPI) systems. At the same time, it retains the simplified architecture and
  high performance of the original.
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
endef

define Package/amneziawg-go/install
	# создаём папки
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/libexec

	# ставим настоящий бинарь в /usr/libexec
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/amneziawg-go $(1)/usr/libexec/amneziawg-go.bin

	# создаём обёртку-скрипт в /usr/bin
	echo '#!/bin/sh' > $(1)/usr/bin/amneziawg-go
	echo 'exec /usr/libexec/amneziawg-go.bin "$$@"' >> $(1)/usr/bin/amneziawg-go
	chmod 0755 $(1)/usr/bin/amneziawg-go
endef

$(eval $(call BuildPackage,amneziawg-go))
