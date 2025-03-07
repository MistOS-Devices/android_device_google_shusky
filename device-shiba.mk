#
# Copyright (C) 2021 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Restrict the visibility of Android.bp files to improve build analysis time
$(call inherit-product-if-exists, vendor/google/products/sources_pixel.mk)

ifdef RELEASE_GOOGLE_SHIBA_RADIO_DIR
RELEASE_GOOGLE_PRODUCT_RADIO_DIR := $(RELEASE_GOOGLE_SHIBA_RADIO_DIR)
endif
ifdef RELEASE_GOOGLE_SHIBA_RADIOCFG_DIR
RELEASE_GOOGLE_PRODUCT_RADIOCFG_DIR := $(RELEASE_GOOGLE_SHIBA_RADIOCFG_DIR)
endif
RELEASE_GOOGLE_BOOTLOADER_SHIBA_DIR ?= pdk# Keep this for pdk TODO: b/327119000
RELEASE_GOOGLE_PRODUCT_BOOTLOADER_DIR := bootloader/$(RELEASE_GOOGLE_BOOTLOADER_SHIBA_DIR)
$(call soong_config_set,shusky_bootloader,prebuilt_dir,$(RELEASE_GOOGLE_BOOTLOADER_SHIBA_DIR))


TARGET_LINUX_KERNEL_VERSION := $(RELEASE_KERNEL_SHIBA_VERSION)
# Keeps flexibility for kasan and ufs builds
TARGET_KERNEL_DIR ?= $(RELEASE_KERNEL_SHIBA_DIR)
TARGET_BOARD_KERNEL_HEADERS ?= $(RELEASE_KERNEL_SHIBA_DIR)/kernel-headers

LOCAL_PATH := device/google/shusky

ifneq ($(TARGET_BOOTS_16K),true)
PRODUCT_16K_DEVELOPER_OPTION := $(RELEASE_GOOGLE_SHIBA_16K_DEVELOPER_OPTION)
endif

$(call inherit-product-if-exists, vendor/google_devices/shusky/prebuilts/device-vendor-shiba.mk)
$(call inherit-product-if-exists, vendor/google_devices/zuma/prebuilts/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/zuma/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/shusky/proprietary/shiba/device-vendor-shiba.mk)
$(call inherit-product-if-exists, vendor/google_devices/shiba/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/shusky/proprietary/WallpapersShiba.mk)

DEVICE_PACKAGE_OVERLAYS += device/google/shusky/shiba/overlay
CAMERA_PRODUCT ?= shiba

ifeq ($(RELEASE_PIXEL_AIDL_AUDIO_HAL_ZUMA),true)
USE_AUDIO_HAL_AIDL := true
endif

include device/google/shusky/camera/camera.mk
include device/google/shusky/audio/shiba/audio-tables.mk
include device/google/zuma/device-shipping-common.mk
include hardware/google/pixel/vibrator/cs40l26/device.mk
include device/google/gs-common/bcmbt/bluetooth.mk
include device/google/gs-common/touch/gti/gti.mk

# Init files
PRODUCT_COPY_FILES += \
	device/google/shusky/conf/init.shiba.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.shiba.rc

# Recovery files
PRODUCT_COPY_FILES += \
        device/google/shusky/conf/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.shiba.rc

# MIPI Coex Configs
PRODUCT_COPY_FILES += \
        device/google/shusky/shiba/radio/shiba_camera_front_dbr_coex_table.csv:$(TARGET_COPY_OUT_VENDOR)/etc/modem/camera_front_dbr_coex_table.csv \
        device/google/shusky/shiba/radio/shiba_camera_front_mipi_coex_table.csv:$(TARGET_COPY_OUT_VENDOR)/etc/modem/camera_front_mipi_coex_table.csv \
		device/google/shusky/shiba/radio/shiba_display_primary_mipi_coex_table.csv:$(TARGET_COPY_OUT_VENDOR)/etc/modem/display_primary_mipi_coex_table.csv

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
        persist.vendor.camera.rls_range_supported=false

# NFC
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
	frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
	frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
	frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
	device/google/shusky/nfc/libnfc-hal-st.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st.conf \
	device/google/shusky/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf

PRODUCT_PACKAGES += \
	$(RELEASE_PACKAGE_NFC_STACK) \
	Tag \
	android.hardware.nfc-service.st

# SecureElement
PRODUCT_PACKAGES += \
	android.hardware.secure_element-service.thales

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
	frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
	device/google/shusky/nfc/libse-gto-hal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libse-gto-hal.conf

# Bluetooth HAL
PRODUCT_COPY_FILES += \
	device/google/shusky/bluetooth/bt_vendor_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor_overlay.conf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.a2dp_offload.supported=true \
    persist.bluetooth.a2dp_offload.disabled=false \
    persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac-opus

# Enable Bluetooth AutoOn feature
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.server.automatic_turn_on=true

# Bluetooth Tx power caps
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_CA.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_CA.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_EU.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_EU.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_JP.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_JP.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_US.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_US.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_GKWS6_CA.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GKWS6_CA.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_GKWS6_EU.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GKWS6_EU.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_GKWS6_JP.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GKWS6_JP.csv \
	$(LOCAL_PATH)/bluetooth/bluetooth_power_limits_shiba_GKWS6_US.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_GKWS6_US.csv

# POF
PRODUCT_PRODUCT_PROPERTIES += \
    ro.bluetooth.finder.supported=true

ifeq ($(USE_AUDIO_HAL_AIDL),true)
# AIDL

# declare use of stereo spatialization
PRODUCT_PROPERTY_OVERRIDES += \
	ro.audio.stereo_spatialization_enabled=true

else
# HIDL

# Spatial Audio
PRODUCT_PACKAGES += \
	libspatialaudio

# Sound Dose
PRODUCT_PACKAGES += \
	android.hardware.audio.sounddose-vendor-impl \
	audio_sounddose_aoc

endif

# declare use of spatial audio
PRODUCT_PROPERTY_OVERRIDES += \
	ro.audio.spatializer_enabled=true

# Audio CCA property
PRODUCT_PROPERTY_OVERRIDES += \
	persist.vendor.audio.cca.enabled=false

# DCK properties based on target
PRODUCT_PROPERTY_OVERRIDES += \
    ro.gms.dck.eligible_wcc=2 \
    ro.gms.dck.se_capability=1

# Bluetooth hci_inject test tool
PRODUCT_PACKAGES_ENG += \
    hci_inject

# Bluetooth OPUS codec
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.opus.enabled=true

# Bluetooth SAR test tool
PRODUCT_PACKAGES_ENG += \
    sar_test

# Bluetooth EWP test tool
PRODUCT_PACKAGES_ENG += \
    ewp_tool

# Bluetooth AAC VBR
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.a2dp_aac.vbr_supported=true

# Override BQR mask to enable LE Audio Choppy report, remove BTRT logging
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.bqr.event_mask=295006 \
    persist.bluetooth.bqr.vnd_quality_mask=29 \
    persist.bluetooth.bqr.vnd_trace_mask=0 \
    persist.bluetooth.vendor.btsnoop=true
else
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.bqr.event_mask=295006 \
    persist.bluetooth.bqr.vnd_quality_mask=16 \
    persist.bluetooth.bqr.vnd_trace_mask=0 \
    persist.bluetooth.vendor.btsnoop=false
endif

# Spatial Audio
PRODUCT_PACKAGES += \
	libspatialaudio \
	librondo

# Bluetooth Super Wide Band
PRODUCT_PRODUCT_PROPERTIES += \
	bluetooth.hfp.swb.supported=true

# Bluetooth LE Audio
PRODUCT_PRODUCT_PROPERTIES += \
	ro.bluetooth.leaudio_switcher.supported?=true \
	bluetooth.profile.bap.unicast.client.enabled?=true \
	bluetooth.profile.csip.set_coordinator.enabled?=true \
	bluetooth.profile.hap.client.enabled?=true \
	bluetooth.profile.mcp.server.enabled?=true \
	bluetooth.profile.ccp.server.enabled?=true \
	bluetooth.profile.vcp.controller.enabled?=true

ifeq ($(RELEASE_PIXEL_BROADCAST_ENABLED), true)
PRODUCT_PRODUCT_PROPERTIES += \
	bluetooth.profile.bap.broadcast.assist.enabled=true \
	bluetooth.profile.bap.broadcast.source.enabled=true
endif

# Bluetooth LE Audio enable hardware offloading
PRODUCT_PRODUCT_PROPERTIES += \
	ro.bluetooth.leaudio_offload.supported=true \
	persist.bluetooth.leaudio_offload.disabled=false

# Bluetooth LE Auido offload capabilities setting
PRODUCT_COPY_FILES += \
	device/google/shusky/bluetooth/le_audio_codec_capabilities.xml:$(TARGET_COPY_OUT_VENDOR)/etc/le_audio_codec_capabilities.xml

# LE Audio Unicast Allowlist
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.leaudio.allow_list=SM-R510,WF-1000XM5

# Bluetooth LE Audio CIS handover to SCO
# Set the property only for the controller couldn't support CIS/SCO simultaneously. More detailed in b/242908683.
PRODUCT_PRODUCT_PROPERTIES += \
	persist.bluetooth.leaudio.notify.idle.during.call=true

# Support LE Audio dual mic SWB call
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.leaudio.dual_bidirection_swb.supported=true

# Support LE & Classic concurrent encryption (b/330704060)
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.ble.allow_enc_with_bredr=true

# Support One-Handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Keymaster HAL
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# Gatekeeper HAL
#LOCAL_GATEKEEPER_PRODUCT_PACKAGE ?= android.hardware.gatekeeper@1.0-service.software


# Gatekeeper
# PRODUCT_PACKAGES += \
# 	android.hardware.gatekeeper@1.0-service.software

# Keymint replaces Keymaster
# PRODUCT_PACKAGES += \
# 	android.hardware.security.keymint-service

# Keymaster
#PRODUCT_PACKAGES += \
#	android.hardware.keymaster@4.0-impl \
#	android.hardware.keymaster@4.0-service

#PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.remote
#PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.remote
#LOCAL_KEYMASTER_PRODUCT_PACKAGE := android.hardware.keymaster@4.1-service
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# PRODUCT_PROPERTY_OVERRIDES += \
# 	ro.hardware.keystore_desede=true \
# 	ro.hardware.keystore=software \
# 	ro.hardware.gatekeeper=software

# PowerStats HAL
PRODUCT_SOONG_NAMESPACES += \
    device/google/shusky/powerstats/shiba \
    device/google/shusky

# WiFi Overlay
PRODUCT_PACKAGES += \
	WifiOverlay2023 \
	PixelWifiOverlay2023

# Trusty liboemcrypto.so
PRODUCT_SOONG_NAMESPACES += vendor/google_devices/shusky/prebuilts

# Location
# SDK build system
include device/google/gs-common/gps/brcm/device.mk

PRODUCT_COPY_FILES += \
       device/google/shusky/location/gps.cer:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.cer

# Location
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        device/google/shusky/location/lhd.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/lhd.conf \
        device/google/shusky/location/scd.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/scd.conf
    ifneq (,$(filter 6.1, $(TARGET_LINUX_KERNEL_VERSION)))
        PRODUCT_COPY_FILES += \
            device/google/shusky/location/gps.6.1.xml.sb3:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    else
        PRODUCT_COPY_FILES += \
            device/google/shusky/location/gps.xml.sb3:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    endif
else
    PRODUCT_COPY_FILES += \
        device/google/shusky/location/lhd_user.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/lhd.conf \
        device/google/shusky/location/scd_user.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/scd.conf
    ifneq (,$(filter 6.1, $(TARGET_LINUX_KERNEL_VERSION)))
        PRODUCT_COPY_FILES += \
            device/google/shusky/location/gps_user.6.1.xml.sb3:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    else
        PRODUCT_COPY_FILES += \
            device/google/shusky/location/gps_user.xml.sb3:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
    endif
endif

# Set zram size
PRODUCT_VENDOR_PROPERTIES += \
	vendor.zram.size=50p \
	persist.device_config.configuration.disable_rescue_party=true

# Fingerprint HAL
GOODIX_CONFIG_BUILD_VERSION := g7_trusty
APEX_FPS_TA_DIR := //vendor/google_devices/shusky/prebuilts
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_common.mk)
ifeq ($(filter factory%, $(TARGET_PRODUCT)),)
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_shipping.mk)
else
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_factory.mk)
endif

# Fingerprint exposure compensation
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.udfps.auto_exposure_compensation_supported=true

# Display
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_idle_timer_ms=1000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.ignore_hdr_camera_layers=true
# lhbm peak brightness delay: decided by kernel
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.primarydisplay.lhbm.frames_to_reach_peak_brightness=0

# display color data
PRODUCT_COPY_FILES += \
	device/google/shusky/shiba/panel_config_google-bigsurf_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/panel_config_google-bigsurf_cal0.pb \
	device/google/shusky/shiba/panel_config_google-shoreline_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/panel_config_google-shoreline_cal0.pb

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.udfps.als_feed_forward_supported=true \
    persist.vendor.udfps.lhbm_controlled_in_hal_supported=true

PRODUCT_COPY_FILES += \
	device/google/shusky/shiba/display_colordata_google-bigsurf_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_colordata_google-bigsurf_cal0.pb \
	device/google/shusky/shiba/display_colordata_google-shoreline_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_colordata_google-shoreline_cal0.pb \
    device/google/shusky/shiba/display_golden_google-bigsurf_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_golden_google-bigsurf_cal0.pb \
    device/google/shusky/shiba/display_golden_google-shoreline_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_golden_google-shoreline_cal0.pb \
    device/google/shusky/display_golden_external_display_cal2.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_golden_external_display_cal2.pb

# Camera Vendor property
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.front_720P_always_binning=true

# Media Performance Class 14
PRODUCT_PRODUCT_PROPERTIES += ro.odm.build.media_performance_class=34

# Display LBE
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1

# Vibrator HAL
$(call soong_config_set,haptics,kernel_ver,v$(subst .,_,$(TARGET_LINUX_KERNEL_VERSION)))
ACTUATOR_MODEL := luxshare_ict_081545
ADAPTIVE_HAPTICS_FEATURE := adaptive_haptics_v1
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.vibrator.hal.chirp.enabled=0 \
    ro.vendor.vibrator.hal.device.mass=0.187 \
    ro.vendor.vibrator.hal.loc.coeff=2.75 \
    persist.vendor.vibrator.hal.context.enable=false \
    persist.vendor.vibrator.hal.context.scale=60 \
    persist.vendor.vibrator.hal.context.fade=true \
    persist.vendor.vibrator.hal.context.cooldowntime=1600 \
    persist.vendor.vibrator.hal.context.settlingtime=5000 \
    ro.vendor.vibrator.hal.dbc.enable=true \
    ro.vendor.vibrator.hal.dbc.envrelcoef=8353728 \
    ro.vendor.vibrator.hal.dbc.riseheadroom=1909602 \
    ro.vendor.vibrator.hal.dbc.fallheadroom=1909602 \
    ro.vendor.vibrator.hal.dbc.txlvlthreshfs=2516583 \
    ro.vendor.vibrator.hal.dbc.txlvlholdoffms=0 \
    ro.vendor.vibrator.hal.pm.activetimeout=5

# Override Output Distortion Gain
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.hapticgenerator.distortion.output.gain=0.38

# Increment the SVN for any official public releases
ifdef RELEASE_SVN_SHIBA
TARGET_SVN ?= $(RELEASE_SVN_SHIBA)
else
# Set this for older releases that don't use build flag
TARGET_SVN ?= 38
endif

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.build.svn=$(TARGET_SVN)

# Set device family property for SMR
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.device_family=HK3SB3AK3

# Set build properties for SMR builds
ifeq ($(RELEASE_IS_SMR), true)
    ifneq (,$(RELEASE_BASE_OS_SHIBA))
        PRODUCT_BASE_OS := $(RELEASE_BASE_OS_SHIBA)
    endif
endif

# Set build properties for EMR builds
ifeq ($(RELEASE_IS_EMR), true)
    ifneq (,$(RELEASE_BASE_OS_SHIBA))
        PRODUCT_PROPERTY_OVERRIDES += \
        ro.build.version.emergency_base_os=$(RELEASE_BASE_OS_SHIBA)
    endif
endif
# P23 Devices no longer need rlsservice
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.rls_supported=false

# WLC userdebug specific
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        device/google/zuma/init.hardware.wlc.rc.userdebug:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.wlc.rc
endif

# Setup Wizard device-specific settings
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.feature.enable_quick_start_flow=true \

# Quick Start device-specific settings
PRODUCT_PRODUCT_PROPERTIES += \
    ro.quick_start.oem_id=00e0 \
    ro.quick_start.device_id=shiba

# PKVM Memory Reclaim
PRODUCT_VENDOR_PROPERTIES += \
    hypervisor.memory_reclaim.supported=1

# Settings Overlay
PRODUCT_PACKAGES += \
    SettingsShibaOverlay

# Window Extensions
$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Disable Settings large-screen optimization enabled by Window Extensions
PRODUCT_SYSTEM_PROPERTIES += \
    persist.settings.large_screen_opt.enabled=false

# Keyboard bottom padding in dp for portrait mode
PRODUCT_PRODUCT_PROPERTIES += \
     ro.com.google.ime.kb_pad_port_b=8

# Enable camera exif model/make reporting
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.exif_reveal_make_model=true

# Enable DeviceAsWebcam support
PRODUCT_VENDOR_PROPERTIES += \
    ro.usb.uvc.enabled=true

PRODUCT_PACKAGES += \
    NfcOverlayShiba

# Set support hide display cutout feature
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_hide_display_cutout=true

PRODUCT_PACKAGES += \
    NoCutoutOverlay \
    AvoidAppsInCutoutOverlay

# ETM
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
$(call inherit-product-if-exists, device/google/common/etm/device-userdebug-modules.mk)
endif

PRODUCT_NO_BIONIC_PAGE_SIZE_MACRO := true

ifneq ($(wildcard vendor/arm/mali/valhall),)
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := true
endif

# Bluetooth device id
# Shiba: 0x410E
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.device_id.product_id=16654

# Set support for LEA multicodec
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.core.le_audio.codec_extension_aidl.enabled=true

# LE Audio configuration scenarios
PRODUCT_COPY_FILES += \
    device/google/shusky/bluetooth/audio_set_scenarios.json:$(TARGET_COPY_OUT_VENDOR)/etc/aidl/le_audio/aidl_audio_set_scenarios.json

PRODUCT_COPY_FILES += \
    device/google/shusky/bluetooth/audio_set_configurations.json:$(TARGET_COPY_OUT_VENDOR)/etc/aidl/le_audio/aidl_audio_set_configurations.json
