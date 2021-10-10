CC=gcc
INCLUDE_DIRS=-I./include/ -I.

.PHONY : default_target
default_target: all

.PHONY : all
all: foundation_utils.so

%.so: %.o
	$(CC) $(INCLUDE_DIRS) -fPIC -shared -Wall -Werror -lc $< -o $@

%.o: %.c
	$(CC) $(INCLUDE_DIRS) -fPIC -Wall -Werror -O3 -c $< -o $@

clean:
	rm -v *.so
