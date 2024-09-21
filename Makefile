KVERSION := $(shell bitbake -e virtual/kernel | grep ^PV= | cut -d'=' -f2 | tr -d '"')
KDIR := $(shell bitbake -e virtual/kernel | grep ^STAGING_KERNEL_DIR= | cut -d'=' -f2 | tr -d '"')

default:
	$(MAKE) -C $(KDIR) M=$$PWD

install: default
	$(MAKE) -C $(KDIR) M=$$PWD modules_install
	depmod -A

remove:
	rmmod hid-logitech 2> /dev/null || true
	rmmod hid-logitech-new 2> /dev/null || true

load: install remove
	modprobe hid-logitech-new ${OPTIONS}

load_debug: install remove
	modprobe hid-logitech-new dyndbg=+p ${OPTIONS}

unload:
	rmmod hid-logitech-new
	modprobe hid-logitech

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean

