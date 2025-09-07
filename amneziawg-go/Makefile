include $(TOPDIR)/rules.mk

PKG_NAME:=amneziawg-go
PKG_VERSION:=0.2.15
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/amnezia-vpn/$(PKG_NAME)/archive/refs/tags/v$(PKG_VERSION)/
PKG_HASH:=skip

PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/golang.mk

# Переменные для кросс-компиляции
PKG_BUILD_ARCH ?= amd64
PKG_BUILD_ARM ?= 0

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

# Компиляция Go с явным использованием PATH (т.е. Go из setup-go на GitHub Actions)
define Build/Compile
	cd $(PKG_BUILD_DIR) && \
		GOOS=linux \
		GOARCH=$(PKG_BUILD_ARCH) \
		$(if $(PKG_BUILD_ARM),GOARM=$(PKG_BUILD_ARM)) \
		CGO_ENABLED=0 \
		$(GO) build -v -trimpath \
		-ldflags "-X main.Build=$(PKG_VERSION)" \
		-o $(PKG_BUILD_DIR)/amneziawg-go .
endef

define Package/amneziawg-go/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/amneziawg-go $(1)/usr/bin/amneziawg-go
endef

$(eval $(call BuildPackage,amneziawg-go))
