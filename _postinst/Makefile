ARCHS = arm64 arm64e
GO_EASY_ON_ME := 1
DEBUG = 0

TARGET = iphone:14.5:11.0
MIN_IOS_SDK_VERSION = 7.0

TOOL_NAME = postinst
postinst_FILES = postinst.mm
postinst_FRAMEWORKS = UIKit
postinst_INSTALL_PATH = /DEBIAN
postinst_CODESIGN_FLAGS = -Sentitlements.xml
postinst_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tool.mk
