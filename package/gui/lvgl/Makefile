include $(TOPDIR)/rules.mk

PKG_NAME:=lvgl
PKG_VERSION:=9.2.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/lvgl/lvgl.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=skip

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENCE.txt
PKG_MAINTAINER:=Zynq Developer

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/lvgl
  SECTION:=gui
  CATEGORY:=GUI
  TITLE:=Light and Versatile Graphics Library
  URL:=https://lvgl.io
  DEPENDS:=+libpthread +libstdcpp
endef

define Package/lvgl/description
  LVGL is a free and open-source graphics library providing everything
  you need to create embedded GUI with easy-to-use graphical elements,
  beautiful visual effects and low memory footprint.
endef

CMAKE_OPTIONS += \
	-DLV_CONF_BUILD_DISABLE_EXAMPLES=ON \
	-DLV_CONF_BUILD_DISABLE_DEMOS=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_SHARED_LIBS=ON

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/lvgl
	$(CP) $(PKG_INSTALL_DIR)/usr/include/lvgl/* $(1)/usr/include/lvgl/ || \
	$(CP) $(PKG_BUILD_DIR)/src/*.h $(1)/usr/include/lvgl/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/liblvgl*.so* $(1)/usr/lib/ || true
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/lvgl.pc $(1)/usr/lib/pkgconfig/ || true
endef

define Package/lvgl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/liblvgl*.so* $(1)/usr/lib/ || true
endef

$(eval $(call BuildPackage,lvgl))
