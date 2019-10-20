CC=gcc
SRC=bits.c dumer.c isd.c xoroshiro128plus.c
OBJ=$(SRC:%.c=%.o)
DEP=$(SRC:%.c=%.d)
LFLAGS=-fopenmp
CFLAGS=-Wall -Wextra -std=gnu11 -I ./m4ri/ $(OPT) $(EXTRA)
LIBS=./m4ri/.libs/libm4ri.a
ifdef PROFGEN
    CFLAGS+=-fprofile-generate
endif
ifdef PROFUSE
    CFLAGS+=-fprofile-use -fprofile-correction
endif

default: avx2

avx2:
	make OPT="-Ofast -march=native -flto" isd

format:
	clang-format -i -verbose -style=google *.c *.h

isd: $(OBJ)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@ $(LFLAGS)

isd.o: isd.c
	$(CC) $(CFLAGS) -MMD -fopenmp -c -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -MMD -c -o $@ $<

-include $(DEP)

clean:
	- /bin/rm isd $(OBJ) $(DEP)