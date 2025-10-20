#!/bin/bash
# OpenWrt Zynq 自动集成 PetaLinux BOOT.BIN 脚本
# 用途：在 OpenWrt 构建过程中自动使用 PetaLinux 的 BOOT.BIN

set -e

PETALINUX_BOOT="/home/user/work/zynq/petalinux-project/HelloZynq_Linux/images/linux/BOOT.BIN"
OPENWRT_BOOT="/home/user/work/zynq/openwrt_source/openwrt/staging_dir/target-arm_cortex-a9+neon_musl_eabi/image/your_vendor_zynq-your_board-boot.bin"

echo "========================================="
echo "OpenWrt Zynq BOOT.BIN 自动集成脚本"
echo "========================================="
echo ""

# 检查 PetaLinux BOOT.BIN
if [ ! -f "$PETALINUX_BOOT" ]; then
    echo "❌ 错误: 找不到 PetaLinux BOOT.BIN"
    echo "   路径: $PETALINUX_BOOT"
    exit 1
fi

echo "✅ 找到 PetaLinux BOOT.BIN"
PETALINUX_MD5=$(md5sum "$PETALINUX_BOOT" | awk '{print $1}')
echo "   MD5: $PETALINUX_MD5"
echo "   大小: $(ls -lh "$PETALINUX_BOOT" | awk '{print $5}')"
echo ""

# 备份当前 boot.bin
if [ -f "$OPENWRT_BOOT" ]; then
    CURRENT_MD5=$(md5sum "$OPENWRT_BOOT" | awk '{print $1}')
    if [ "$CURRENT_MD5" = "$PETALINUX_MD5" ]; then
        echo "ℹ️  当前已是 PetaLinux BOOT.BIN，无需更新"
        exit 0
    fi
    
    BACKUP="${OPENWRT_BOOT}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$OPENWRT_BOOT" "$BACKUP"
    echo "📦 已备份当前 boot.bin 到:"
    echo "   $BACKUP"
    echo ""
fi

# 复制 PetaLinux BOOT.BIN
echo "📋 复制 PetaLinux BOOT.BIN..."
cp "$PETALINUX_BOOT" "$OPENWRT_BOOT"

# 验证
NEW_MD5=$(md5sum "$OPENWRT_BOOT" | awk '{print $1}')
if [ "$NEW_MD5" = "$PETALINUX_MD5" ]; then
    echo "✅ 成功! MD5 验证通过"
else
    echo "❌ 错误: MD5 不匹配"
    exit 1
fi

echo ""
echo "========================================="
echo "✅ BOOT.BIN 已更新"
echo "========================================="
echo ""
echo "下一步："
echo "1. 运行: cd /home/user/work/zynq/openwrt_source/openwrt"
echo "2. 运行: make target/linux/install"
echo "3. 镜像将包含 PetaLinux BOOT.BIN"
echo ""
