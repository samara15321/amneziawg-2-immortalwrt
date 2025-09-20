# SPDX-License-Identifier: MIT

include $(TOPDIR)/rules.mk

PKG_NAME:=amneziawg-go
PKG_VERSION:=2.0.3
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/amnezia-vpn/amneziawg-go.git
PKG_SOURCE_VERSION:=f6542209f40f3f8f9e3dc9403d331ad2881fd7e3

PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/amnezia-vpn/amneziawg-go
GO_PKG_LDFLAGS_X:=main.Build=$(PKG_VERSION)
GO_PKG_NO_STRIP:=1

# Отключаем сборку под неподдерживаемые архитектуры
ifeq ($(ARCH),loongarch64)
  PKG_ARCH:=no
endif
ifeq ($(ARCH),powerpc)
  PKG_ARCH:=no
endif
ifeq ($(ARCH),armeb_xscale)
  PKG_ARCH:=no
endif
ifeq ($(ARCH),mips64_octeonplus)
  PKG_ARCH:=no
endif

include $(INCLUDE_DIR)/package.mk

define Package/amneziawg-go
  SECTION:=net
  CATEGORY:=Network
  TITLE:=AmneziaWG userspace implementation program (written in Go)
  DEPENDS:=+kmod-tun
endef

define Package/amneziawg-go/description
  AmneziaWG is a contemporary version of the WireGuard protocol.
  It's a fork of WireGuard-Go and offers protection against DPI detection.
endef

cd $(PKG_BUILD_DIR) && \
  GOOS=linux \
  GOARCH=$(GOARCH) \
  GOCACHE=$(PKG_BUILD_DIR)/.gocache \
  go build -mod=mod \
  -ldflags "$(GO_PKG_LDFLAGS_X)" \
  -o amneziawg-go ./cmd/amneziawg-go

define Package/amneziawg-go/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/amneziawg-go $(1)/usr/bin/amneziawg-go
endef

$(eval $(call BuildPackage,amneziawg-go))
