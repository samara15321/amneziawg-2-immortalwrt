include $(TOPDIR)/rules.mk

PKG_NAME:=amneziawg-go
PKG_VERSION:=1.0.20250813
PKG_RELEASE:=1

GO ?= go

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/amnezia-vpn/amneziawg-go.git
PKG_SOURCE_VERSION:=15d7259cd45f41d50bc5838dc002698362f29a2d
PKG_MIRROR_HASH:=d277d34653d2d7885e7b01b6b4037adb3d466cd85c17d857a488cbd4ec60f928

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
ifeq ($(ARCH),powerpc64)
  GOARCH:=ppc64
endif
ifeq ($(ARCH),powerpc64le)
  GOARCH:=ppc64le
endif
ifeq ($(ARCH),powerpc)
  GOARCH:=ppc
endif

# Неподдерживаемые
ifeq ($(ARCH),armeb_xscale)
  GOARCH:=unsupported
endif
ifeq ($(ARCH),mips64_octeonplus)
  GOARCH:=unsupported
endif
ifeq ($(ARCH),loongarch64)
  GOARCH:=unsupported
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

# --- Ключевой момент: отключаем strip/patchelf ---
PKG_BUILD_FLAGS:=no-mips16 no-strip

define Build/Compile
$(if $(filter unsupported,$(GOARCH)), \
	@echo "Skipping build: amneziawg-go not supported on $(ARCH)", \
	cd $(PKG_BUILD_DIR) && \
	GOOS=linux \
	GOARCH=$(GOARCH) \
	$(if $(GOARM),GOARM=$(GOARM)) \
	CGO_ENABLED=0 \
	$(GO) build -v -trimpath -ldflags "-s -w -X main.Build=$(PKG_VERSION)" \
	-o $(PKG_BUILD_DIR)/amneziawg-go . \
)
endef

define Package/amneziawg-go/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/amneziawg-go $(1)/usr/bin/amneziawg-go
endef

$(eval $(call BuildPackage,amneziawg-go))
