include $(TOPDIR)/rules.mk

PKG_NAME:=fb-demo
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/fb-demo
  SECTION:=gui
  CATEGORY:=GUI
  TITLE:=Simple Framebuffer Demo for Zynq
  DEPENDS:=+libpthread
endef

define Package/fb-demo/description
  A simple framebuffer demo application for Zynq OpenWrt
  Displays a basic GUI without external dependencies
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-o $(PKG_BUILD_DIR)/fb-demo \
		$(PKG_BUILD_DIR)/main.c \
		-lpthread -lm
endef

define Package/fb-demo/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fb-demo $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/fb-demo.init $(1)/etc/init.d/fb-demo
endef

$(eval $(call BuildPackage,fb-demo))
