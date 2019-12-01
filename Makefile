include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Orion

Orion_FILES = Tweak.x
Orion_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
