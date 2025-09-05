# This is free software, licensed under the MIT License.

include $(TOPDIR)/rules.mk

PKG_NAME:=amneziawg-go
PKG_VERSION:=0.2.15
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/amnezia-vpn/$(PKG_NAME)/archive/refs/tags/v$(PKG_VERSION)/
PKG_HASH:=skip

PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/amnezia-vpn/amneziawg-go

include $(INCLUDE_DIR)/package.mk

define Package/amneziawg-go
  SECTION:=net
  CATEGORY:=Network
  TITLE:=AmneziaWG userspace implementation program (written in Go)
  DEPENDS:=+kmod-tun
endef

define Build/Compile
	# Используем системный Go
	export PATH := /opt/hostedtoolcache/go/1.24.6/x64/bin:$$PATH
	export GOROOT := /opt/hostedtoolcache/go/1.24.6/x64
	export GOPATH := $(CURDIR)/.go_work
	mkdir -p $$(GOPATH)/src
	cd $$(GOPATH)/src
	go mod tidy
	go build -ldflags "-X main.Build=$(PKG_VERSION)" -o $(PKG_INSTALL_DIR)/usr/bin/amneziawg-go $(GO_PKG)/...
endef

define Package/amneziawg-go/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/amneziawg-go $(1)/usr/bin/amneziawg-go
endef

define Package/amneziawg-go/description
  AmneziaWG is a contemporary version of the WireGuard protocol. It's a fork of
  WireGuard-Go and offers protection against detection by Deep Packet Inspection
  (DPI) systems. At the same time, it retains the simplified architecture and
  high performance of the original.
endef

$(eval $(call BuildPackage,amneziawg-go))
