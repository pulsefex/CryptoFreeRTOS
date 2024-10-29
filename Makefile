CC = arm-none-eabi-gcc
CFLAGS = -Wall -O2 -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -DUSE_HAL_DRIVER -DSTM32WBxx -DconfigUSE_PREEMPTION=1 -DconfigUSE_IDLE_HOOK=0 -DconfigUSE_TICK_HOOK=0 -DconfigCPU_CLOCK_HZ=64000000 -DconfigTICK_RATE_HZ=1000 -DconfigMAX_PRIORITIES=7 -DconfigMINIMAL_STACK_SIZE=128 -DconfigTOTAL_HEAP_SIZE=15360 -IInclude -Itinycrypt/lib/include -ISource

all: build_dirs build/pulsefex.elf

build_dirs:
	mkdir -p build build/Source build/tinycrypt/lib/source

build/Source/%.o: Source/%.c | build_dirs
	$(CC) $(CFLAGS) -c $< -o $@

build/tinycrypt/lib/source/%.o: tinycrypt/lib/source/%.c | build_dirs
	$(CC) $(CFLAGS) -c $< -o $@

build/%.o: %.s | build_dirs
	$(CC) $(CFLAGS) -c $< -o $@

build/main.o: main.c | build_dirs
	$(CC) $(CFLAGS) -c main.c -o build/main.o

build/pulsefex.elf: build/Source/FreeRTOS.o build/Source/list.o build/Source/queue.o build/Source/task.o build/Source/timers.o build/Source/logger.o build/Source/user_auth.o build/tinycrypt/lib/source/aes_decrypt.o build/tinycrypt/lib/source/aes_encrypt.o build/tinycrypt/lib/source/cbc_mode.o build/tinycrypt/lib/source/ccm_mode.o build/tinycrypt/lib/source/cmac_mode.o build/tinycrypt/lib/source/ctr_mode.o build/tinycrypt/lib/source/ctr_prng.o build/tinycrypt/lib/source/ecc.o build/tinycrypt/lib/source/ecc_dh.o build/tinycrypt/lib/source/ecc_dsa.o build/tinycrypt/lib/source/ecc_platform_specific.o build/tinycrypt/lib/source/hmac.o build/tinycrypt/lib/source/hmac_prng.o build/tinycrypt/lib/source/sha256.o build/tinycrypt/lib/source/utils.o build/startup_stm32wb55xx_cm4.o build/main.o
	$(CC) $(CFLAGS) $^ -TSTM32WB.ld -Wl,--gc-sections -o $@

clean:
	rm -rf build
