HEX_LIST = \
	collections/Paint.hex \
	collections/STM32F429I-DISCOVERY_Demo_V1.0.1.hex

BIN_LIST = $(HEX_LIST:collections/%.hex=%.bin)
TARGET_LIST = $(HEX_LIST:collections/%.hex=%)
%.bin: collections/%.hex
	arm-none-eabi-objcopy -I ihex -O binary $< $@

all: $(BIN_LIST)

FLASH_TARGETS = $(addprefix flash-,$(TARGET_LIST))

$(FLASH_TARGETS): $(BIN_LIST)
	st-flash write $(@:flash-%=%).bin 0x8000000

list: $(HEX_LIST)
	@echo "Firmware:" $(addsuffix ";",$(TARGET_LIST))

clean:
	rm -f $(BIN_LIST)
