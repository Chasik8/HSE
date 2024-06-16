CFLAGS ?= -O2 -g

CFLAGS += -std=gnu99

CFLAGS += -Wall -Werror -Wformat-security -Wignored-qualifiers -Winit-self \
	-Wswitch-default -Wpointer-arith -Wtype-limits -Wempty-body \
	-Wstrict-prototypes -Wold-style-declaration -Wold-style-definition \
	-Wmissing-parameter-type -Wmissing-field-initializers -Wnested-externs \
	-Wstack-usage=4096 -Wmissing-prototypes -Wfloat-equal -Wabsolute-value

CFLAGS += -fsanitize=undefined -fsanitize-undefined-trap-on-error
CC=gcc
CC += -m32
ASMC := nasm
ASMFLAGS := --gprefix _ -f win32
LDLIBS = -lm
.PHONY: all

all: run

test: test.o function.o integral.o
	$(CC) $(CFLAGS) $^ -o $@

run: run.o function.o integral.o
	$(CC) $(CFLAGS) $^ -o $@

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o : %.asm
	$(ASMC) $(ASMFLAGS) $< -o $@

clean:
	del /Q D:\Project\C\VS\HSE\*.o
