include $(TOPDIR)/rules.mk

PKG_NAME:=amneziawg-go
PKG_VERSION:=0.2.15
PKG_RELEASE:=$(AUTORELEASE)

GO ?= go

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/amnezia-vpn/$(PKG_NAME)/archive/refs/tags/v$(PKG_VERSION)/
PKG_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

# === Маппинг архитектур OpenWrt → GOARCH/GOARM ===
GOARCH:=$(ARCH)
GOARM:=

# x86
ifeq ($(ARCH),i386)
  GOARCH:=386
endif
ifeq ($(ARCH),x86_64)
  GOARCH:=amd64
endif

# ARM 32-bit
ifeq ($(ARCH),arm)
  GOARCH:=arm
  ifneq (,$(findstring armv7,$(CONFIG_CPU_TYPE)))
    GOARM:=7
  else ifneq (,$(findstring armv6,$(CONFIG_CPU_TYPE)))
    GOARM:=6
  endif
endif

# ARM 64-bit
ifeq ($(ARCH),aarch64)
  GOARCH:=arm64
endif

# MIPS
ifeq ($(ARCH),mips)
  GOARCH:=mips
endif
ifeq ($(ARCH),mipsel)
  GOARCH:=mipsle
endif
ifeq ($(ARCH),mips64)
  GOARCH:=mips64
endif
ifeq ($(ARCH),mips64el)
  GOARCH:=mips64le
endif

# RISC-V
ifeq ($(ARCH),riscv64)
  GOARCH:=riscv64
endif

# PowerPC
ifeq ($(ARCH),powerpc)
  GOARCH:=unsupported
endif
ifeq ($(ARCH),powerpc64)
  GOARCH:=ppc64
endif
ifeq ($(ARCH),powerpc64le)
  GOARCH:=ppc64le
endif

define Package/amneziawg-go
  SECTION:=net
  CATEGORY:=Network
  TITLE:=AmneziaWG userspace implementation (Go)
  DEPENDS:=+kmod-tun
endef

define Package/amneziawg-go/description
AmneziaWG is a fork of WireGuard-Go with DPI-resistance features.
endef

define Build/Compile
ifneq ($(GOARCH),unsupported)
	cd $(PKG_BUILD_DIR) && \
		GOOS=linux \
		GOARCH=$(GOARCH) \
		$(if $(GOARM),GOARM=$(GOARM)) \
		CGO_ENABLED=0 \
		$(GO) build -v -trimpath \
			-ldflags "-X main.Build=$(PKG_VERSION)" \
			-o $(PKG_BUILD_DIR)/amneziawg-go .
else
	@echo "Skipping build: amneziawg-go not supported on $(ARCH)"
endif
endef

define Package/amneziawg-go/install
ifneq ($(GOARCH),unsupported)
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/amneziawg-go $(1)/usr/bin/amneziawg-go
else
	@echo "Skipping install: amneziawg-go not built on $(ARCH)"
endif
endef

$(eval $(call BuildPackage,amneziawg-go))
