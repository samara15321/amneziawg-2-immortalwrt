include $(TOPDIR)/rules.mk

LUCI_TITLE:=Support for AmneziaWG VPN
PKG_NAME:=luci-proto-amneziawg
PKG_VERSION:=1.0.20250813
LUCI_DEPENDS:=+amneziawg-tools +ucode +luci-lib-uqr +resolveip
LUCI_PKGARCH:=all

PKG_PROVIDES:=luci-proto-amneziawg

include $(TOPDIR)/feeds/luci/luci.mk

# Генерация локализации из po/ru/amneziawg.po
define Build/Compile
	$(call Build/Compile/LuaPackage)
endef

# Установка файлов
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/proto
	$(INSTALL_DATA) ./htdocs/luci-static/resources/* $(1)/usr/lib/lua/luci/proto/
endef

# Запуск стандартной сборки LuCI
$(eval $(call BuildPackage,luci-proto-amneziawg))
