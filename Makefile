include theos/makefiles/common.mk

TWEAK_NAME = NotiCopy
NotiCopy_FILES = Tweak.xm
NotiCopy_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
