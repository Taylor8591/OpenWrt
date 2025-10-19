define Device/your_vendor_zynq-your-board
	$(call Device/FitImageGzip)
	DEVICE_VENDOR := YourVendor
	DEVICE_MODEL := YourBoard
	IMAGES := sdcard.img.gz
	IMAGE/sdcard.img.gz := zynq-sdcard | gzip
endef
TARGET_DEVICES += your_vendor_zynq-your-board