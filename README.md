# vc4boot

VideoCore IV boot programs:
- hello.bin
- dumpotp.bin
- vpuinfo.bin

To build the boot program, run `make hello.bin`. It should then be installed
as `bootcode.bin` in the SD card boot partition.

You can also build an ELF binary (`make hello.elf`). Install it as `start.elf`
or `start4.elf` (for Raspberry Pi 4) in the boot partition.
