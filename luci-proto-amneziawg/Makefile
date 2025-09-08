include $(TOPDIR)/rules.mk

LUCI_TITLE:=Support for AmneziaWG VPN
PKG_VERSION:=1.0.20250813
LUCI_DEPENDS:=+amneziawg-tools +ucode +luci-lib-uqr +resolveip
LUCI_PKGARCH:=all

PKG_PROVIDES:=luci-proto-amneziawg

include $(TOPDIR)/feeds/luci/luci.mk

# Список .po файлов
POFILES:= \
	$(CURDIR)/po/amneziawg.po \
	$(CURDIR)/po/status.po

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Compile
	# Компилируем все .po файлы в .mo
	$(foreach po,$(POFILES), \
		msgfmt --output-file=$(PKG_BUILD_DIR)/$(notdir $(po:.po=.mo)) $(po); \
	)
endef

define Package/luci-proto-amneziawg/install
	# Устанавливаем .mo файлы в i18n
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(foreach po,$(POFILES), \
		$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(notdir $(po:.po=.mo)) $(1)/usr/lib/lua/luci/i18n/; \
	)
	# Устанавливаем модель CBI
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/luasrc/model/cbi/amneziawg.lua $(1)/usr/lib/lua/luci/model/cbi/
endef

$(eval $(call BuildPackage,luci-proto-amneziawg))
