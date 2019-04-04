.include "mmio.inc"
.include "uart.inc"

	.global uart_putcrlf
uart_putcrlf:
	mov r0, 0x0a0d

	.global uart_putchars
uart_putchars:
	mov r1, UART1_BASE
.L_nextchar:
1:
	ld  r2, (r1 + UART_AUX_MU_LSR_REG)
	btest r2, 5
	beq 1b

	st  r0, (r1 + UART_AUX_MU_IO_REG)
	lsr r0, 8
	bne r0, 0, .L_nextchar
	rts
