AS=vc4-as
AR=vc4-ar
RANLIB=vc4-ranlib
LD=vc4-ld
OBJCOPY=vc4-objcopy

%.o: %.S
	$(AS) -o $@ $<

%.elf: %.o libvc4.a
	$(LD) -o $@ $^

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

libvc4.a: delay.o ledflash.o uart.o uart_puts.o
	$(AR) cr $@ $^
	$(RANLIB) $@
