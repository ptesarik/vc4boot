.include "mmio.inc"
.include "uart.inc"

	.global uart_puthexword
uart_puthexword:
	mov r1, UART1_BASE
	mov r4, 8
.L_nextdigit:
	lsr r3, r0, 28
	add r3, '0'
	bls r3, '9', 1f
	add r3, 'a' - '0' - 10
1:
	ld  r2, (r1 + UART_AUX_MU_LSR_REG)
	btest r2, 5
	beq  1b

	shl r0, 4
	st  r3, (r1 + UART_AUX_MU_IO_REG)
	addcmpbgt r4, -1, 0, .L_nextdigit
	rts
