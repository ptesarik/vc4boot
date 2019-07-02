.include "mmio.inc"

	.text
	.org 0x200

	.global _start
_start:
	mov r0, CM_VPUCTL
	bl  clk_get_freq
	bl uart_init

	;; Print Hello, world!\r\n
	lea r0, hello_world
	bl  uart_puts

	b led_flash

hello_world:	.asciz "Hello, world!\r\n"
