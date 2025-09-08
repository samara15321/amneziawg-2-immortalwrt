include $(TOPDIR)/rules.mk

LUCI_TITLE:=Support for AmneziaWG VPN
PKG_VERSION:=1.0.20250813
LUCI_DEPENDS:=+amneziawg-tools +ucode +luci-lib-uqr +resolveip
LUCI_PKGARCH:=all

PKG_PROVIDES:=luci-proto-amneziawg

include $(TOPDIR)/feeds/luci/luci.mk

# Указываем все .po файлы для компиляции
POFILES:= \
	$(CURDIR)/po/amneziawg.po \
	$(CURDIR)/po/status.po

define Build/Prepare
	$(call Build/Prepare/Default)
	$(foreach po,$(POFILES), \
		msgfmt --output-file=$(PKG_BUILD_DIR)/$(notdir $(po:.po=.mo)) $(po); \
	)
endef

define Package/luci-proto-amneziawg/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	# Копируем скомпилированные .mo файлы
	$(foreach po,$(POFILES), \
		$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(notdir $(po:.po=.mo)) $(1)/usr/lib/lua/luci/i18n/; \
	)
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/luasrc/model/cbi/amneziawg.lua $(1)/usr/lib/lua/luci/model/cbi/
endef

$(eval $(call BuildPackage,luci-proto-amneziawg))
