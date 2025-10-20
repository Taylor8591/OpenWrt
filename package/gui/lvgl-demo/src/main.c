#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

/* 简化的 LVGL Demo - 直接使用 Framebuffer */

static int fbfd = 0;
static struct fb_var_screeninfo vinfo;
static struct fb_fix_screeninfo finfo;
static long screensize = 0;
static char *fbp = NULL;
static volatile int keep_running = 1;

void signal_handler(int sig) {
    keep_running = 0;
}

/* 简单的绘图函数 */
void draw_pixel(int x, int y, uint32_t color) {
    if (x >= 0 && x < vinfo.xres && y >= 0 && y < vinfo.yres) {
        long location = (x + vinfo.xoffset) * (vinfo.bits_per_pixel / 8) +
                       (y + vinfo.yoffset) * finfo.line_length;
        *((uint32_t*)(fbp + location)) = color;
    }
}

void draw_rectangle(int x, int y, int width, int height, uint32_t color) {
    for (int i = x; i < x + width; i++) {
        for (int j = y; j < y + height; j++) {
            draw_pixel(i, j, color);
        }
    }
}

void draw_text_simple(int x, int y, const char *text, uint32_t color) {
    /* 简单的文本绘制 - 实际应用中应使用字体库 */
    printf("Drawing text at (%d,%d): %s\n", x, y, text);
}

void create_demo_ui() {
    /* 清屏 - 填充背景色 */
    draw_rectangle(0, 0, vinfo.xres, vinfo.yres, 0xFF282828);
    
    /* 绘制标题区域 */
    draw_rectangle(0, 0, vinfo.xres, 80, 0xFF1E88E5);
    
    /* 绘制主体区域 */
    draw_rectangle(50, 100, vinfo.xres - 100, vinfo.yres - 200, 0xFF424242);
    
    /* 绘制按钮 */
    int btn_x = (vinfo.xres - 200) / 2;
    int btn_y = (vinfo.yres - 60) / 2;
    draw_rectangle(btn_x, btn_y, 200, 60, 0xFF4CAF50);
    
    /* 绘制进度条 */
    int bar_x = (vinfo.xres - 300) / 2;
    int bar_y = vinfo.yres - 150;
    draw_rectangle(bar_x, bar_y, 300, 20, 0xFF757575);
    draw_rectangle(bar_x, bar_y, 210, 20, 0xFF2196F3);  /* 70% */
    
    /* 绘制状态指示器 */
    draw_rectangle(20, 20, 40, 40, 0xFF4CAF50);  /* 绿色状态灯 */
    
    printf("UI drawn successfully!\n");
}

int main(void) {
    /* 设置信号处理 */
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);

    printf("\n");
    printf("========================================\n");
    printf("  Zynq OpenWrt LVGL Demo\n");
    printf("========================================\n");
    printf("\n");

    /* 打开 framebuffer 设备 */
    fbfd = open("/dev/fb0", O_RDWR);
    if (fbfd == -1) {
        perror("Error: cannot open framebuffer device");
        printf("Make sure /dev/fb0 exists and you have permission to access it\n");
        return 1;
    }
    printf("✓ Framebuffer device opened\n");

    /* 获取固定屏幕信息 */
    if (ioctl(fbfd, FBIOGET_FSCREENINFO, &finfo) == -1) {
        perror("Error reading fixed information");
        close(fbfd);
        return 1;
    }

    /* 获取可变屏幕信息 */
    if (ioctl(fbfd, FBIOGET_VSCREENINFO, &vinfo) == -1) {
        perror("Error reading variable information");
        close(fbfd);
        return 1;
    }

    printf("✓ Display info:\n");
    printf("  Resolution: %dx%d\n", vinfo.xres, vinfo.yres);
    printf("  Bits per pixel: %d\n", vinfo.bits_per_pixel);
    printf("  Line length: %d bytes\n", finfo.line_length);

    /* 计算屏幕大小 */
    screensize = vinfo.yres_virtual * finfo.line_length;

    /* 映射 framebuffer 到内存 */
    fbp = (char *)mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fbfd, 0);
    if (fbp == MAP_FAILED) {
        perror("Error: failed to map framebuffer device to memory");
        close(fbfd);
        return 1;
    }
    printf("✓ Framebuffer mapped to memory (%ld bytes)\n", screensize);

    /* 创建演示 UI */
    printf("\nCreating demo UI...\n");
    create_demo_ui();

    printf("\nDemo UI is running. Press Ctrl+C to exit.\n");
    printf("----------------------------------------\n");
    printf("Display Information:\n");
    printf("  - Blue header bar at top\n");
    printf("  - Gray content area in center\n");
    printf("  - Green button in middle\n");
    printf("  - Blue progress bar (70%%) near bottom\n");
    printf("  - Green status indicator in top-left\n");
    printf("========================================\n\n");

    /* 主循环 - 保持运行 */
    int counter = 0;
    while(keep_running) {
        sleep(1);
        counter++;
        
        /* 每5秒更新一次状态 */
        if (counter % 5 == 0) {
            printf("Status: Running for %d seconds...\n", counter);
        }
    }

    /* 清理 */
    printf("\nShutting down...\n");
    munmap(fbp, screensize);
    close(fbfd);
    printf("Goodbye!\n");

    return 0;
}
