# st version
VERSION = 0.3

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/local/include
X11LIB = /usr/local/lib

# includes and libs
INCS = -I. -I/usr/local/include -I${X11INC} \
       $(shell pkg-config --cflags fontconfig) \
       $(shell pkg-config --cflags freetype2)
LIBS = -L/usr/local/lib -lc -L${X11LIB} -lX11 -lutil -lXext -lXft \
       $(shell pkg-config --libs fontconfig)  \
       $(shell pkg-config --libs freetype2)

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\" -D_BSD_SOURCE -D_XOPEN_SOURCE=600
CFLAGS += -g -std=c99 -pedantic -Wall -Wvariadic-macros -Os ${INCS} ${CPPFLAGS}
LDFLAGS += -lm -g ${LIBS}

# compiler and linker
CC ?= gcc47

