#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

PROG = ctfdiff
SRCS = ctfdiff.c

include ../../Makefile.ctf
include ../../Makefile.ctf.post

CFLAGS += $(CCVERBOSE)
LDLIBS += -lctf
NATIVE_LIBS += libc.so

LDFLAGS = \
	-L$(ROOTONBLDLIBMACH) \
	'-R$$ORIGIN/../../lib/$(MACH)' \
	$(BDIRECT)

CPPFLAGS += -include ../../common/ctf_headers.h

OBJS = $(SRCS:%.c=%.o)

all: $(PROG)

$(PROG): $(OBJS)
	$(LINK.c) $(OBJS) -o $@ $(LDLIBS)
	$(POST_PROCESS)

%.o: $(SRC)/cmd/ctfdiff/%.c
	$(COMPILE.c) $<

$(ROOTONBLDMACHPROG): $(PROG)

install: $(ROOTONBLDMACHPROG)

clean:
	$(RM) $(OBJS)

include $(SRC)/tools/Makefile.targ
