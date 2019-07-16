.include "mmio.inc"
.include "uart.inc"

	.global uart_flush
uart_flush:
	mov r1, UART1_BASE
1:
	ld  r0, (r1 + UART_AUX_MU_LSR_REG)
	btest r0, 6
	beq 1b
	rts
