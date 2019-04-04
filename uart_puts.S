.include "mmio.inc"
.include "uart.inc"

	.global uart_puts
uart_puts:
	mov r1, UART1_BASE
.L_nextchar:
	ldb r3, (r0++)
	beq r3, 0, .L_exit
1:
	ld  r2, (r1 + UART_AUX_MU_LSR_REG)
	btest r2, 5
	beq 1b

	st  r3, (r1 + UART_AUX_MU_IO_REG)
	b .L_nextchar

.L_exit:
	rts
