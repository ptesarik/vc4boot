.include "mmio.inc"
.include "uart.inc"

	.global uart_putdecword
uart_putdecword:
	stm lr,(--sp)
	mov r3, 0
	mov r1, sp
	add sp, -12
	stb r3, (--r1)
.L_nextdigit:
	div.uu r2, r0, 10
	mul r3, r2, 10
	rsub r3, r0
	add r3, '0'
	stb r3, (--r1)
	mov r0, r2
	bne r0, 0, .L_nextdigit

	mov r0, r1
	bl  uart_puts
	add sp, 12
	ldm pc,(sp++)
