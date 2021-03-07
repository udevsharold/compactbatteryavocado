ARCHS = arm64 arm64e

TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CompactBatteryAvocadoPrefs

CompactBatteryAvocadoPrefs_FILES = CompactBatteryAvocadoRootListController.m
CompactBatteryAvocadoPrefs_FRAMEWORKS = UIKit
CompactBatteryAvocadoPrefs_PRIVATE_FRAMEWORKS = Preferences
CompactBatteryAvocadoPrefs_INSTALL_PATH = /Library/PreferenceBundles
CompactBatteryAvocadoPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
