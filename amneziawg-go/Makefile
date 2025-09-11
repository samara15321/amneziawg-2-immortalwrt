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

# Go package info
GO_PKG:=github.com/amnezia-vpn/amneziawg-go

# Явно отключаем strip: не используем -s -w
GO_PKG_LDFLAGS:=
GO_PKG_LDFLAGS_X:=main.Build=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include ../../packages/lang/golang/golang-package.mk

# Перезаписываем GO_PKG_LDFLAGS чтобы не подставлялось -s -w
GO_PKG_LDFLAGS:=$(GO_PKG_LDFLAGS_X)

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
	@echo "=== Building $(PKG_NAME) with ldflags: $(GO_PKG_LDFLAGS) ==="
	$(call GoPackage/Build/Compile)
endef

define Package/amneziawg-go/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
endef

$(eval $(call BuildPackage,amneziawg-go))
