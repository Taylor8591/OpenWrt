# SPDX-License-Identifier: GPL-2.0

include $(TOPDIR)/rules.mk

PKG_NAME:=myfpga
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/firmware-myfpga
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=My FPGA bitstream
  DEPENDS:=
endef

define Package/firmware-myfpga/description
  Installs the FPGA bitstream to /lib/firmware so the kernel or userspace
  components can load it at runtime.
endef

# 把预置的 bitstream 放到 package/files/ 目录，安装到 /lib/firmware
define Build/Prepare
	# Nothing to build
	true
endef

define Build/Compile
	true
endef

define Package/firmware-myfpga/install
	$(INSTALL_DIR) $(1)/lib/firmware
	# 将 package/files/ 下的 bitstream 复制到固件目录
	$(CP) $(CURDIR)/files/* $(1)/lib/firmware/
endef

$(eval $(call BuildPackage,firmware-myfpga))
