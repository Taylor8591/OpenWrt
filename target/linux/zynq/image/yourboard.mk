define Device/your_vendor_zynq-your_board
	$(call Device/FitImageGzip)
	DEVICE_VENDOR := YourVendor
	DEVICE_MODEL := YourBoard
	DEVICE_DTS := zynq-your-board
	IMAGES := sdcard.img.gz
	IMAGE/sdcard.img.gz := zynq-sdcard | gzip
endef
TARGET_DEVICES += your_vendor_zynq-your_board