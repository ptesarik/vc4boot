AS=vc4-elf-as
AR=vc4-elf-ar
RANLIB=vc4-elf-ranlib
LD=vc4-elf-ld
OBJCOPY=vc4-elf-objcopy

%.o: %.S
	$(AS) -o $@ $<

%.elf: %.o libvc4.a
	$(LD) -o $@ $^

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

libvc4.a: delay.o ledflash.o uart.o uart_putchars.o uart_puthex.o uart_puts.o
	$(AR) cr $@ $^
	$(RANLIB) $@
