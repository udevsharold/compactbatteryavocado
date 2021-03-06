export ARCHS = arm64 arm64e

export DEBUG = 0
export FINALPACKAGE = 1

export PREFIX = $(THEOS)/toolchain/Xcode11.xctoolchain/usr/bin/

TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CompactBatteryAvocado

CompactBatteryAvocado_FILES = CompactBatteryAvocado.xm
CompactBatteryAvocado_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += compactbatteryavocadoprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
