#
# Make file to compile cthreads.c
LDFLAGS=-pthread 
CC=gcc

#Our final target executable program will be named cthreads 
TARGET = mycthreads

# source files
SOURCES = mycthreads.c

# work out names of object files from sources
OBJECTS = $(SOURCES:.c=.o)

# compiler flags (we do not include -c here as it's dealt with by the
# appropriate rules; CXXFLAGS gets passed as part of command
# invocation for both compilation (where -c is needed) and linking
# (where it's not.)
CXXFLAGS = -lpthread

# default target (to build all)
all: ${TARGET}

# clean target
clean:
	rm ${OBJECTS} ${TARGET}

# rule to link object files to create target executable
# $@ is the target, here $(TARGET), and $^ is all the
# dependencies separated by spaces (duplicates removed),
# here ${OBJECTS}
${TARGET}: ${OBJECTS}
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)
