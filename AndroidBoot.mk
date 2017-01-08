#Android makefile to build bootloader as a part of Android Build

CLANG_BIN := $(ANDROID_BUILD_TOP)/$(LLVM_PREBUILTS_PATH)/

ifeq ($(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_SUPPORTS_VERITY),true)
	VERIFIED_BOOT := VERIFIED_BOOT=0
else
	VERIFIED_BOOT := VERIFIED_BOOT=0
endif

ifeq ($(TARGET_BUILD_VARIANT),user)
	USER_BUILD_VARIANT := USER_BUILD_VARIANT=1
else
	USER_BUILD_VARIANT := USER_BUILD_VARIANT=0
endif

# ABL ELF output
TARGET_ABL := $(PRODUCT_OUT)/abl.elf
TARGET_EMMC_BOOTLOADER := $(TARGET_ABL)
ABL_OUT := $(TARGET_OUT_INTERMEDIATES)/ABL_OBJ

abl_clean:
	$(hide) rm -f $(TARGET_ABL)

$(ABL_OUT):
	mkdir -p $(ABL_OUT)

# Top level target
$(TARGET_ABL): abl_clean | $(ABL_OUT) $(INSTALLED_KEYSTOREIMAGE_TARGET)
	$(MAKE) -C bootable/bootloader/edk2 BOOTLOADER_OUT=../../../$(ABL_OUT) all $(VERIFIED_BOOT) $(USER_BUILD_VARIANT) CLANG_BIN=$(CLANG_BIN)

.PHONY: abl

abl: $(TARGET_ABL)
