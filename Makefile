
TOOLCHAIN_PREFIX=arm-none-eabi-
CC=$(TOOLCHAIN_PREFIX)gcc
AR=$(TOOLCHAIN_PREFIX)ar
LD=$(TOOLCHAIN_PREFIX)ld
SZ=$(TOOLCHAIN_PREFIX)size
RM := rm -rf

LIBRARY_NAME = lpc_chip_43xx_m0
SRC_DIR = src/
BUILD_DIR = ./build/
ILIBS = -I./inc -I./inc/config_m0app

CORE = m0
GLOBAL_DEFS = -D__LPC43XX__ -DCORE_M0
CFLAGS = -O0 -g3 -Wall -c -fmessage-length=0 -fno-builtin -ffunction-sections -fdata-sections -std=gnu99 -mcpu=cortex-$(CORE) -mthumb -MMD -MP


SRCS = $(shell find $(SRC_DIR) -name '*.c')
OBJS_F :=  $(addprefix $(BUILD_DIR), $(SRCS:.c=.o))
LIBRARY_FILE = "./lib$(LIBRARY_NAME).a"


all: post-build


.SECONDEXPANSION:
$(LIBRARY_FILE) : $$(OBJS_F)
	@mkdir -p "$(BUILD_DIR)"
	@echo 'Building target: $@'
	@echo 'Invoking: MCU Archiver'
	 
	$(AR) -r  $@ $(OBJS_F) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '
	#$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(BUILD_DIR)
	-$(RM) $(LIBRARY_FILE)
	-@echo ' '


post-build: $(LIBRARY_FILE)
	-@echo 'Performing post-build steps'
	$(SZ) $(LIBRARY_FILE)
	-@echo ' '
	-@echo ' '
	-@echo ' '

$(BUILD_DIR)%.o: %.c
	mkdir -p '$(dir $@)'
	@echo 'Building file: $@ in $(BUILD_DIR) from $<'
	@echo 'Invoking: MCU C Compiler'
	@echo flags=$(CFLAGS)
	$(CC) $(GLOBAL_DEFS) $(ILIBS) $(CFLAGS) -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

.PHONY: all post-build clean dependents
.SECONDARY:

