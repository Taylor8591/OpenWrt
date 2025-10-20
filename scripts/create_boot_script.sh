#!/bin/bash
# 
# 创建 U-Boot 启动脚本（boot.scr）
# 用于替代不工作的 uEnv.txt
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENWRT_DIR="/home/user/work/zynq/openwrt_source/openwrt"

echo "=== 创建 U-Boot 启动脚本 ==="

# 创建启动脚本内容
cat > /tmp/boot.cmd <<'EOF'
# OpenWrt Zynq Boot Script

echo "=== OpenWrt Zynq Boot Script ==="

# 设置内核参数
setenv bootargs console=ttyPS0,115200n8 root=/dev/mmcblk0p2 rootwait earlyprintk

# 加载并启动内核
echo "Loading image.ub from SD card..."
if fatload mmc 0:1 ${kernel_addr_r} image.ub; then
    echo "Booting kernel..."
    bootm ${kernel_addr_r}
else
    echo "Failed to load image.ub"
    echo "Trying distro boot..."
    run distro_bootcmd
fi
EOF

# 编译为 U-Boot 脚本
echo "编译 boot.scr..."
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "OpenWrt Boot Script" \
        -d /tmp/boot.cmd /tmp/boot.scr

if [ $? -eq 0 ]; then
    echo "✅ boot.scr 创建成功"
    ls -lh /tmp/boot.scr
    
    # 复制到 staging 目录
    STAGING_DIR="${OPENWRT_DIR}/staging_dir/target-arm_cortex-a9+neon_musl_eabi/image"
    if [ -d "$STAGING_DIR" ]; then
        cp /tmp/boot.scr "${STAGING_DIR}/your_vendor_zynq-your_board-boot.scr"
        echo "✅ 已复制到 staging 目录"
    fi
else
    echo "❌ boot.scr 创建失败"
    exit 1
fi

echo "
"
echo "=== 说明 ==="
echo "boot.scr 是一个 U-Boot 脚本，U-Boot 会自动搜索并执行它。"
echo ""
echo "下一步："
echo "1. 修改 target/linux/zynq/image/Makefile，添加："
echo "   mcopy -i \$@.boot \$(STAGING_DIR_IMAGE)/\$(DEVICE_NAME)-boot.scr ::boot.scr"
echo ""
echo "2. 重新构建镜像："
echo "   make target/linux/install"
echo ""
