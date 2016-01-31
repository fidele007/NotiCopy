export THEOS_DEVICE_IP = 127.0.0.1
export THEOS_DEVICE_PORT = 2222

ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = NotiCopy
NotiCopy_FILES = Tweak.xm
NotiCopy_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
