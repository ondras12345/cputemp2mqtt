.PHONY: installdirs install uninstall help

# PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

# I'm not sure if this is correct, everyone seems to be using a custom script
# for this.
MKINSTALLDIRS = mkdir -p

EXEC_PREFIX = $(PREFIX)
BINDIR = $(EXEC_PREFIX)/bin

# https://gist.github.com/prwhite/8168133
help:       ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e '/unique_BhwaDzu7C/d;s/\\$$//;s/##//'

installdirs:
	$(MKINSTALLDIRS) $(DESTDIR)$(BINDIR) \
	                 $(DESTDIR)/etc/systemd/system \
	                 $(DESTDIR)/etc

install:    ## Install the script, it's config file and systemd unit file
install: installdirs
	$(INSTALL_PROGRAM) cputemp2mqtt $(DESTDIR)$(BINDIR)/cputemp2mqtt
	$(INSTALL_DATA) cputemp2mqtt.service $(DESTDIR)/etc/systemd/system/cputemp2mqtt.service
	$(INSTALL_DATA) cputemp2mqtt.conf $(DESTDIR)/etc/cputemp2mqtt

uninstall:  ## Uninstall everything -- TODO implement this
