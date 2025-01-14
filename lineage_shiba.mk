#
# SPDX-FileCopyrightText: 2021-2024 The LineageOS Project
# SPDX-FileCopyrightText: 2021-2024 The Calyx Institute
# SPDX-License-Identifier: Apache-2.0
#

# Inherit some common stuff
TARGET_DISABLE_EPPE := true
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
DEVICE_CODENAME := shiba
DEVICE_PATH := device/google/shusky
VENDOR_PATH := vendor/google/shiba
$(call inherit-product, $(DEVICE_PATH)/aosp_$(DEVICE_CODENAME).mk)
$(call inherit-product, device/google/zuma/lineage_common.mk)
$(call inherit-product, $(DEVICE_PATH)/$(DEVICE_CODENAME)/device-lineage.mk)

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 8
PRODUCT_NAME := lineage_$(DEVICE_CODENAME)

# UDFPS support
TARGET_HAS_UDFPS := true
EXTRA_UDFPS_ANIMATIONS := true

# Blur
TARGET_ENABLE_BLUR := true

# BCR (Call recording)
TARGET_PREBUILT_BCR := true

# Lawnchair (Pixel launcher by default)
TARGET_INCLUDE_PIXEL_LAUNCHER := true
TARGET_DEFAULT_PIXEL_LAUNCHER := true
TARGET_PREBUILT_LAWNCHAIR_LAUNCHER := true

# Exclude Aperture camera
PRODUCT_NO_CAMERA := true

# Google Camera App
TARGET_PREBUILT_GOOGLE_CAMERA := true

# Custom package installer
TARGET_USE_CUSTOM_PACKAGE_INSTALLER := true

# Live wallpapers
TARGET_INCLUDE_LIVE_WALLPAPERS := true

# Quick tap
TARGET_SUPPORTS_QUICK_TAP  := true

# Now Playing
TARGET_SUPPORTS_NOW_PLAYING := true

# Clear Calling
TARGET_SUPPORTS_CLEAR_CALLING := true

# Call Recording Support
TARGET_SUPPORTS_CALL_RECORDING := true

# Pixel Carrier Settings
TARGET_INCLUDE_CARRIER_SETTINGS := true
TARGET_INCLUDE_PIXEL_IMS := true
TARGET_INCLUDE_PIXEL_EUICC := true
TARGET_INCLUDE_CARRIER_SERVICES := true

# A bunch of Pixel stuff
USE_PIXEL_CHARGER := true
TARGET_SUPPORTS_DREAMLINER := true
TARGET_SUPPORTS_GOOGLE_BATTERY := true
TARGET_SUPPORTS_ADPATIVE_CHARGING := true
TARGET_SUPPORTS_GOOGLE_RECORDER := true
TARGET_INCLUDE_STOCK_ARCORE := true
TARGET_SUPPORTS_GOOGLE_CAMERA := true
TARGET_GOOGLE_CAMERA_LARGE_RAM := true
TARGET_PIXEL_EXPERIENCE_2023 := true

# GMS
WITH_GMS := true
BUILD_GOOGLE_CONTACTS := true
BUILD_GOOGLE_DIALER := true
BUILD_GOOGLE_MESSAGE := true

# Mist OS Flags
MIST_BUILD_TYPE := OFFICIAL
MISTOS_MAINTAINER := GamerBoy1234294

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080
TARGET_BOOT_ANIMATION_RES := 1080

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="shiba-user 15 AP4A.250105.002 12701944 release-keys" \
    BuildFingerprint=google/shiba/shiba:15/AP4A.250105.002/12701944:user/release-keys \
    DeviceProduct=$(DEVICE_CODENAME)

$(call inherit-product, $(VENDOR_PATH)/$(DEVICE_CODENAME)-vendor.mk)
