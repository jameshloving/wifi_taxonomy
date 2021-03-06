PYTHON?=python

all: build

test: wifi_signature anonymize_pcap
	set -e; \
	for d in $(wildcard tests/*_test.py); do \
		PYTHONPATH=./taxonomy $(PYTHON) $$d; \
	done
	for d in $(wildcard tests/*_test.sh); do \
		$$d; \
	done

PREFIX=/usr

build:
	cd ./taxonomy && $(HOSTDIR)/usr/bin/python setup.py build

install:
	cd ./taxonomy && $(HOSTDIR)/usr/bin/python setup.py install --prefix=$(DESTDIR)$(PREFIX)

install-libs:
	@echo "No libs to install."

CC:=$(CROSS_COMPILE)gcc
CPP:=$(CROSS_COMPILE)g++
LD:=$(CROSS_COMPILE)ld
AR:=$(CROSS_COMPILE)ar
RANLIB:=$(CROSS_COMPILE)ranlib
STRIP:=$(CROSS_COMPILE)strip
BINDIR=$(DESTDIR)/bin

CFLAGS += -g -Os -Wall -Werror $(EXTRACFLAGS)
LDFLAGS += $(EXTRALDFLAGS)
INCS =

wifi_signature: wifi_signature.o $(INCS)
	$(CC) $(CFLAGS) -I$(HOSTDIR)/usr/include wifi_signature.c -o $@ $(LDFLAGS) -lpcap

anonymize_pcap: anonymize_pcap.o $(INCS)
	$(CC) $(CFLAGS) -I$(HOSTDIR)/usr/include anonymize_pcap.c -o $@ $(LDFLAGS) -lpcap

clean:
	rm -f wifi_signature anonymize_pcap *.o taxonomy/*.pyc taxonomy/*.pyo
