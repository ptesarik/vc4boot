AS=vc4-elf-as
AR=vc4-elf-ar
RANLIB=vc4-elf-ranlib
LD=vc4-elf-ld
OBJCOPY=vc4-elf-objcopy

LIBRARY_OBJS = \
	clkgetf.o \
	delay.o \
	ledflash.o \
	memset.o \
	otp.o \
	uart.o \
	uart_putchars.o \
	uart_putdec.o \
	uart_puthex.o \
	uart_puts.o

%.o: %.S
	$(AS) -o $@ $<

%.elf: %.o libvc4.a
	$(LD) -o $@ $^ start_elf.ld

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

libvc4.a: $(LIBRARY_OBJS)
	$(AR) cr $@ $^
	$(RANLIB) $@
