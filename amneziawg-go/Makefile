include $(TOPDIR)/rules.mk

PKG_NAME:=amneziawg-go
PKG_VERSION:=0.2.15
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/amnezia-vpn/$(PKG_NAME)/archive/refs/tags/v$(PKG_VERSION)/
PKG_HASH:=skip

PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

# Используем внешнее Go
override GO := /opt/hostedtoolcache/go/1.24.6/x64/bin/go

# Переменные для архитектуры (будут заданы через CI)
PKG_BUILD_ARCH ?= amd64
PKG_BUILD_ARM ?= 0

include $(INCLUDE_DIR)/package.mk

define Package/amneziawg-go
  SECTION:=net
  CATEGORY:=Network
  TITLE:=AmneziaWG userspace implementation program (written in Go)
  DEPENDS:=+kmod-tun
endef

define Package/amneziawg-go/description
  AmneziaWG is a contemporary version of the WireGuard protocol. It's a fork of
  WireGuard-Go and offers protection against detection by Deep Packet Inspection
  (DPI) systems. At the same time, it retains the simplified architecture and
  high performance of the original.
endef

define Build/Compile
	cd $(PKG_BUILD_DIR) && \
		GOOS=linux \
		GOARCH=$(PKG_BUILD_ARCH) \
		$(if $(PKG_BUILD_ARM),GOARM=$(PKG_BUILD_ARM)) \
		CGO_ENABLED=0 \
		CC="$(TARGET_CC)" \
		$(GO) build -v -trimpath \
		-ldflags "-X main.Build=$(PKG_VERSION)" \
		-o $(PKG_BUILD_DIR)/amneziawg-go .
endef

define Package/amneziawg-go/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/amneziawg-go $(1)/usr/bin/amneziawg-go
endef

$(eval $(call BuildPackage,amneziawg-go))
