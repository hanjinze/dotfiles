# st version
VERSION = 0.3

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = /usr/local/man

X11INC = /usr/local/include
X11LIB = /usr/local/lib

# includes and libs
INCS = -I. -I/usr/include -I${X11INC} -I${X11INC}/freetype2
LIBS = -L/usr/lib -lc -L${X11LIB} -lX11 -lutil -lXext -lXft -lfontconfig

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\"
CFLAGS += -g -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
LDFLAGS += -lm -g ${LIBS}

# compiler and linker
CC ?= cc
