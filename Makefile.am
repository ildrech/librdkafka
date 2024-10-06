###Copyright (C) 2024 Ildar Rechapov <ildar.rch@gmail.com>
###This code is public domain and can be freely used or copied.

ACLOCAL_AMFLAGS = -I m4

AUTOMAKE_OPTIONS=subdir-objects
SUBDIRS = src

### Avoids README complaints from earlier versions of automake.
README: README.md

pkgconfigdir = $(libdir)/pkgconfig

LIBRDKAFKA_PKGCONFIG_DATA = librdkafka.pc

if OPENSSL
LIBRDKAFKA_PKGCONFIG_DATA += libevent_openssl.pc
endif

pkgconfig_DATA = $(LIBRDKAFKA_PKGCONFIG_DATA)

DISTCLEANFILES =

MAINTAINERCLEANFILES = \
    Makefile.in \
    aclocal.m4 \
    ar-lib \
    compile \
    config.guess \
    config.h.in \
    config.h.in~ \
    config.sub \
    configure \
    depcomp \
    install-sh \
    ltmain.sh \
    missing  \
    $(distdir).tar.gz  \
    $(distdir).tar.xz

EXTRA_DIST = \
    autogen.sh \
    CMakeLists.txt \
    README.md \
    librdkafka.pc.in

