CC=gcc
LDFLAGS=
CFLAGS=-Wall -Wextra

BUILD_DIR=build
SRC_DIR=src
TARGET=main

VPATH=$(SRC_DIR)
SRCS=$(foreach dir, $(SRC_DIR), $(wildcard $(dir)/*.c))
OBJS=$(subst $(SRC_DIR), $(BUILD_DIR), $(SRCS:.c=.o))

.PHONY: all run clean

all: $(OBJS)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/$(TARGET) $^ $(LDFLAGS)

$(BUILD_DIR)/%.o: %.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $^ -o $@

run: $(BUILD_DIR)/$(TARGET)
	@$(BUILD_DIR)/$(TARGET)

clean:
	rm $(OBJS) $(BUILD_DIR)/$(TARGET) 2>/dev/null || true
