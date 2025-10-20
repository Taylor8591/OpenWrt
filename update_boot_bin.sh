#!/bin/bash
# OpenWrt Zynq 一键式构建脚本（交互式）
# 用途: 自动更新 BOOT.BIN + 构建镜像 + 显示结果
# 
# 注意: 这是手动使用的交互式版本
#       Makefile 会自动调用 scripts/update_boot_bin.sh
#       
# 使用方法: ./update_boot_bin.sh

set -e  # 遇到错误立即退出

# ===========================
# 配置路径
# ===========================
PETALINUX_BOOT="/home/user/work/zynq/petalinux-project/HelloZynq_Linux/images/linux/BOOT.BIN"
OPENWRT_ROOT="/home/user/work/zynq/openwrt_source/openwrt"
STAGING_BOOT="$OPENWRT_ROOT/staging_dir/target-arm_cortex-a9+neon_musl_eabi/image/your_vendor_zynq-your_board-boot.bin"
IMAGE_DIR="$OPENWRT_ROOT/bin/targets/zynq/yourboard"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ===========================
# 函数定义
# ===========================
print_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# ===========================
# 主流程
# ===========================
print_header "OpenWrt Zynq Boot.bin 更新脚本"

# 1. 检查 PetaLinux BOOT.BIN
echo ""
print_info "检查 PetaLinux BOOT.BIN..."
if [ ! -f "$PETALINUX_BOOT" ]; then
    print_error "找不到 PetaLinux BOOT.BIN"
    echo "   路径: $PETALINUX_BOOT"
    exit 1
fi

PETALINUX_SIZE=$(ls -lh "$PETALINUX_BOOT" | awk '{print $5}')
PETALINUX_MD5=$(md5sum "$PETALINUX_BOOT" | awk '{print $1}')
print_success "找到 PetaLinux BOOT.BIN"
echo "   大小: $PETALINUX_SIZE"
echo "   MD5:  $PETALINUX_MD5"

# 2. 检查当前 boot.bin
echo ""
print_info "检查当前 boot.bin..."
if [ -f "$STAGING_BOOT" ]; then
    OLD_SIZE=$(ls -lh "$STAGING_BOOT" | awk '{print $5}')
    OLD_MD5=$(md5sum "$STAGING_BOOT" | awk '{print $1}')
    echo "   当前大小: $OLD_SIZE"
    echo "   当前 MD5:  $OLD_MD5"
    
    # 检查是否已经是 PetaLinux 版本
    if [ "$OLD_MD5" == "$PETALINUX_MD5" ]; then
        print_warning "当前 boot.bin 已经是 PetaLinux 版本，无需更新"
        echo ""
        read -p "是否仍要重新生成镜像? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "已取消操作"
            exit 0
        fi
    else
        # 备份旧版本
        BACKUP_FILE="$STAGING_BOOT.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$STAGING_BOOT" "$BACKUP_FILE"
        print_success "已备份旧 boot.bin"
        echo "   备份位置: $BACKUP_FILE"
    fi
else
    print_warning "未找到旧的 boot.bin"
fi

# 3. 复制 PetaLinux BOOT.BIN
echo ""
print_info "复制 PetaLinux BOOT.BIN 到 staging 目录..."
cp "$PETALINUX_BOOT" "$STAGING_BOOT"

NEW_SIZE=$(ls -lh "$STAGING_BOOT" | awk '{print $5}')
NEW_MD5=$(md5sum "$STAGING_BOOT" | awk '{print $1}')
print_success "已更新 boot.bin"
echo "   新大小: $NEW_SIZE"
echo "   新 MD5:  $NEW_MD5"

# 4. 验证复制
if [ "$NEW_MD5" != "$PETALINUX_MD5" ]; then
    print_error "MD5 校验失败！复制可能不完整"
    exit 1
fi
print_success "MD5 校验通过"

# 5. 重新生成镜像
echo ""
print_header "重新生成 SD 卡镜像"
cd "$OPENWRT_ROOT"

print_info "开始构建（这可能需要几秒钟）..."
if make target/linux/install 2>&1 | grep -v "^WARNING"; then
    echo ""
    print_success "镜像生成成功！"
else
    echo ""
    print_error "镜像生成失败"
    exit 1
fi

# 6. 显示生成的镜像
echo ""
print_header "生成的镜像文件"
if [ -d "$IMAGE_DIR" ]; then
    echo ""
    ls -lh "$IMAGE_DIR/"*sdcard*.gz | while read line; do
        SIZE=$(echo $line | awk '{print $5}')
        DATE=$(echo $line | awk '{print $6, $7}')
        FILE=$(echo $line | awk '{print $9}')
        FILENAME=$(basename "$FILE")
        echo "  📁 $FILENAME"
        echo "     大小: $SIZE, 生成时间: $DATE"
        echo ""
    done
else
    print_error "找不到镜像目录: $IMAGE_DIR"
    exit 1
fi

# 7. 显示使用说明
print_header "使用说明"
echo ""
echo "推荐使用 squashfs 版本："
echo ""
echo -e "${GREEN}cd $IMAGE_DIR${NC}"
echo -e "${GREEN}gunzip openwrt-zynq-yourboard-your_vendor_zynq-your_board-squashfs-sdcard.img.gz${NC}"
echo -e "${GREEN}sudo dd if=openwrt-zynq-yourboard-your_vendor_zynq-your_board-squashfs-sdcard.img of=/dev/sdX bs=4M status=progress conv=fsync${NC}"
echo -e "${GREEN}sync${NC}"
echo ""
print_warning "请将 /dev/sdX 替换为实际的 SD 卡设备"
echo ""
print_success "全部完成！ 🚀"
