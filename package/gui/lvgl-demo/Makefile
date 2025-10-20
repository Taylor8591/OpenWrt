include $(TOPDIR)/rules.mk

PKG_NAME:=lvgl-demo
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/lvgl-demo
  SECTION:=gui
  CATEGORY:=GUI
  TITLE:=LVGL Demo Application for Zynq
  DEPENDS:=+lvgl +libpthread
endef

define Package/lvgl-demo/description
  A demo application showcasing LVGL on Zynq OpenWrt
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(STAGING_DIR)/usr/include \
		-I$(STAGING_DIR)/usr/include/lvgl \
		-o $(PKG_BUILD_DIR)/lvgl-demo \
		$(PKG_BUILD_DIR)/main.c \
		-llvgl -lpthread -lm
endef

define Package/lvgl-demo/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lvgl-demo $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/lvgl-demo.init $(1)/etc/init.d/lvgl-demo
endef

$(eval $(call BuildPackage,lvgl-demo))
