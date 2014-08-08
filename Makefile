HEX_LIST = \
	collections/Paint.hex \
	collections/STM32F429I-DISCOVERY_Demo_V1.0.1.hex \
	collections/STM32CubeDemo_STM32F429I-Discovery.hex

BIN_LIST = $(HEX_LIST:collections/%.hex=%.bin)
TARGET_LIST = $(HEX_LIST:collections/%.hex=%)
%.bin: collections/%.hex
	arm-none-eabi-objcopy -I ihex -O binary $< $@

all: $(BIN_LIST)

FLASH_TARGETS = $(addprefix flash-,$(TARGET_LIST))

$(FLASH_TARGETS): $(BIN_LIST)
	openocd \
		-f interface/stlink-v2.cfg \
		-f target/stm32f4x_stlink.cfg \
		-c "init" \
		-c "reset init" \
		-c "flash probe 0" \
		-c "flash info 0" \
		-c "flash write_image erase $(@:flash-%=%).bin 0x8000000" \
		-c "reset run" -c shutdown || \
	st-flash write $(@:flash-%=%).bin 0x8000000

list: $(HEX_LIST)
	@echo -e "Firmware:" $(addprefix "\n\t",$(TARGET_LIST))

clean:
	rm -f $(BIN_LIST)
