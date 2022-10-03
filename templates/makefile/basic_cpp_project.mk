CC=gcc
CXX=g++
LDFLAGS=-lstdc++
CFLAGS=-Wall -Wextra

BUILD_DIR=build
SRC_DIR=src
TARGET=main

VPATH=$(SRC_DIR)
SRCS=$(foreach dir, $(SRC_DIR), $(wildcard $(dir)/*.cpp))
OBJS=$(subst $(SRC_DIR), $(BUILD_DIR), $(SRCS:.cpp=.o))

.PHONY: all run clean

all: $(OBJS)
	$(CXX) $(CFLAGS) -o $(BUILD_DIR)/$(TARGET) $^ $(LDFLAGS)

$(OBJS): $(SRCS)
	mkdir -p $(BUILD_DIR)
	$(CXX) $(CFLAGS) -c $< -o $@

run: $(BUILD_DIR)/$(TARGET)
	@$(BUILD_DIR)/$(TARGET)

clean:
	rm $(OBJS) $(BUILD_DIR)/$(TARGET) 2>/dev/null || true
