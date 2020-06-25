# Makefile for building port binaries
#
# Makefile targets:
#
# all/install   build and install the NIF
# clean         clean build products and intermediates
#
# Variables to override:
#
# MIX_COMPILE_PATH path to the build's ebin directory
#
# CC            C compiler
# CROSSCOMPILE	crosscompiler prefix, if any
# CFLAGS	compiler flags for compiling all C files
# ERL_CFLAGS	additional compiler flags for files using Erlang header files
# ERL_EI_INCLUDE_DIR include path to ei.h (Required for crosscompile)
# ERL_EI_LIBDIR path to libei.a (Required for crosscompile)
# LDFLAGS	linker flags for linking all binaries
# ERL_LDFLAGS	additional linker flags for projects referencing Erlang libraries

IW_VERSION := 5.4
IW_DL_URL := https://mirrors.edge.kernel.org/pub/software/network/iw/iw-$(IW_VERSION).tar.xz

ifeq ($(MIX_COMPILE_PATH),)
call_from_make:
	mix compile
endif

PREFIX = $(MIX_APP_PATH)/priv
BUILD  = $(MIX_APP_PATH)/obj

IW_SRC = $(BUILD)/iw-$(IW_VERSION).tar.xz
IW_BIN = $(PREFIX)/usr/sbin/iw

# Check that we're on a supported build platform
ifeq ($(CROSSCOMPILE),)
    # Not crosscompiling, so check that we're on Linux.
    ifneq ($(shell uname -s),Linux)
        $(warning iw only works on Linux, but crosscompilation)
        $(warning is supported by defining $$CROSSCOMPILE, $$ERL_EI_INCLUDE_DIR,)
        $(warning and $$ERL_EI_LIBDIR. See Makefile for details. If using Nerves,)
        $(warning this should be done automatically.)
        $(warning .)
        DEFAULT_TARGETS ?= $(PREFIX)
    endif
endif
DEFAULT_TARGETS ?= $(PREFIX) $(IW_BIN)

all: install

install: $(BUILD) $(PREFIX) $(DEFAULT_TARGETS)

clean: 
	$(RM) -r $(PREFIX)
	$(RM) -r $(BUILD)

$(IW_BIN): $(IW_SRC)
	$(IW_MAKE_ENV) make -C $(BUILD)/iw-$(IW_VERSION) DESTDIR=$(PREFIX) install

$(IW_SRC):
	wget -O $(IW_SRC) $(IW_DL_URL)
	tar xvf $(IW_SRC) -C $(BUILD)

$(PREFIX) $(BUILD):
	mkdir -p $@