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
GO := /opt/hostedtoolcache/go/1.24.6/x64/bin/go

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

# Определяем GOARCH и GOARM по архитектуре OpenWrt
define Build/Compile
	cd $(PKG_BUILD_DIR) && \
		GOOS=linux \
		$(if $(findstring arm,$(CONFIG_ARCH)),GOARCH=arm) \
		$(if $(findstring armeb,$(CONFIG_ARCH)),GOARCH=arm GOARM=5) \
		$(if $(findstring aarch64,$(CONFIG_ARCH)),GOARCH=arm64) \
		$(if $(findstring mipsel,$(CONFIG_ARCH)),GOARCH=mipsle) \
		$(if $(findstring mips64el,$(CONFIG_ARCH)),GOARCH=mips64le) \
		$(if $(findstring mips64,$(CONFIG_ARCH)),GOARCH=mips64) \
		$(if $(findstring mips,$(CONFIG_ARCH)),GOARCH=mips) \
		$(if $(findstring i386,$(CONFIG_ARCH)),GOARCH=386) \
		$(if $(findstring x86_64,$(CONFIG_ARCH)),GOARCH=amd64) \
		$(if $(findstring powerpc64le,$(CONFIG_ARCH)),GOARCH=ppc64le) \
		$(if $(findstring powerpc64,$(CONFIG_ARCH)),GOARCH=ppc64) \
		$(if $(findstring powerpc,$(CONFIG_ARCH)),GOARCH=ppc) \
		$(if $(findstring riscv64,$(CONFIG_ARCH)),GOARCH=riscv64) \
		$(if $(findstring s390x,$(CONFIG_ARCH)),GOARCH=s390x) \
		$(if $(findstring arm,$(CONFIG_ARCH)), \
			$(if $(findstring arm1176jzf-s,$(CONFIG_CPU_TYPE)),GOARM=6) \
			$(if $(findstring cortex-a5,$(CONFIG_CPU_TYPE)),GOARM=7) \
			$(if $(findstring cortex-a7,$(CONFIG_CPU_TYPE)),GOARM=7) \
			$(if $(findstring cortex-a8,$(CONFIG_CPU_TYPE)),GOARM=7) \
			$(if $(findstring cortex-a9,$(CONFIG_CPU_TYPE)),GOARM=7) \
			$(if $(findstring cortex-a15,$(CONFIG_CPU_TYPE)),GOARM=7) \
			$(if $(findstring cortex-a17,$(CONFIG_CPU_TYPE)),GOARM=7) \
			$(if $(findstring cortex-a53,$(CONFIG_CPU_TYPE)),GOARM=7) \
			$(if $(findstring cortex-a72,$(CONFIG_CPU_TYPE)),GOARM=7) \
		) \
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
