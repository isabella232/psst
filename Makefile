VERSION = 0.1

BINDIR = /usr/bin
WARNFLAGS = -Wall -Wformat
CC = gcc
CFLAGS += -D VERSION=\"$(VERSION)\"
CFLAGS += -D_LINUX_ -Wall -O2
DBG_CFLAGS = -DDEBUG -g -O0
LDFLAGS += -DPASS2
TARGET = psst

INSTALL_PROGRAM = install -m 755 -p
DEL_FILE = rm -f

SRC_PATH = ./src
OBJS =  $(SRC_PATH)/parse_config.o $(SRC_PATH)/logger.o $(SRC_PATH)/rapl.o \
	$(SRC_PATH)/perf_msr.o $(SRC_PATH)/psst.o
OBJS +=

psst: $(OBJS) Makefile
	$(CC) ${CFLAGS} $(LDFLAGS) $(OBJS) -o $(TARGET) -lpthread -lrt -lm

install:
	mkdir -p $(BINDIR)
	$(INSTALL_PROGRAM) "$(TARGET)" "$(BINDIR)/$(TARGET)"

uninstall:
	$(DEL_FILE) "$(BINDIR)/$(TARGET)"

clean:
	find . -name "*.o" | xargs $(DEL_FILE)
	rm -f $(TARGET)

dist:
	git tag v$(VERSION)
	git archive --format=tar --prefix="$(TARGET)-$(VERSION)/" v$(VERSION) | \
	gzip > $(TARGET)-$(VERSION).tar.gz
