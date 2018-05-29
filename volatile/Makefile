# Generic Makefile

# project name (name of executable)
TARGET = target

# directory structure
SRC_DIR = src
OBJ_DIR = obj
SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# compiler configuration
CC 				= gcc
RM			  = rm
CFLAGS		= -Wall
INCLUDES	= -Iinclude -I/usr/include/gsl
LDFLAGS 	=
LDLIBS		= -lgsl -lgslcblas -lfftw3

all:	$(TARGET)

$(TARGET):	$(OBJ)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o:	$(SRC_DIR)/%.c
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJ) $(TARGET)

.PHONY:	all clean
