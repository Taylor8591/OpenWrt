include $(TOPDIR)/rules.mk

PKG_NAME:=lvgl2
PKG_VERSION:=9.2.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/lvgl/lvgl.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_HASH:=997f341dd070e0214a34f09fbe6b9d1ddb8528a881d3da36b809543e57777526

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/lvgl2
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=LVGL v2 graphics library
  URL:=https://lvgl.io
endef

define Package/lvgl2/description
  LVGL2 is a lightweight embedded graphics library for displays.
endef

# ---------------- Build ----------------

define Build/Configure
	
endef

define Build/Compile
	true
endef

define Package/lvgl2/install
	$(INSTALL_DIR) $(1)/usr/include/lvgl
	$(CP) -r $(PKG_BUILD_DIR)/src/* $(1)/usr/include/lvgl/
endef

# ---------------- Build ----------------

# define Build/Prepare
# 	mkdir -p $(PKG_BUILD_DIR)
# 	tar -C $(PKG_BUILD_DIR)/.. -xf $(DL_DIR)/$(PKG_SOURCE)
# endef

# define Build/Compile
# 	$(TARGET_CC) -c $(PKG_BUILD_DIR)/src/*.c -I$(PKG_BUILD_DIR)/src -o $(PKG_BUILD_DIR)/lvgl2.o
# 	$(TARGET_AR) rcs $(PKG_BUILD_DIR)/liblvgl.a $(PKG_BUILD_DIR)/lvgl2.o
# endef

# define Build/InstallDev
# 	$(INSTALL_DIR) $(1)/usr/include/lvgl
# 	cp -r $(PKG_BUILD_DIR)/src/* $(1)/usr/include/lvgl/
# 	$(INSTALL_DIR) $(1)/usr/lib
# 	cp $(PKG_BUILD_DIR)/liblvgl.a $(1)/usr/lib/
# endef

# define Package/lvgl2/install
# 	$(INSTALL_DIR) $(1)/usr/include/lvgl
# 	cp -r $(PKG_BUILD_DIR)/src/* $(1)/usr/include/lvgl/
# 	$(INSTALL_DIR) $(1)/usr/lib
# 	cp $(PKG_BUILD_DIR)/liblvgl.a $(1)/usr/lib/
# endef

$(eval $(call BuildPackage,lvgl2))
