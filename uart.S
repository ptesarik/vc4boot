;;;
;;; UART
;;;

.include "mmio.inc"
.include "uart.inc"

	.text

;;; r0 ... base rate (VPU)
;;;
	.global uart_init
uart_init:
	stm lr,(--sp)
	mov r1, TARGET_BAUD_RATE*8
	div.uu r3, r0, r1

	;; Configure TX and RX GPIO pins for Mini Uart function.
	mov r1, GPIO_BASE
	ld  r0, (r1 + GPIO_GPFSEL1)
	and r0, ~(7<<12) & ~(7<<15)
	or  r0,  (2<<12) |  (2<<15)
	st  r0, (r1 + GPIO_GPFSEL1)

	mov r0, 0
	st  r0, (r1 + GPIO_GPPUD)

	mov r0,150
	bl  delay

	mov r0, (1<<14) | (1<<15)
	st  r0, (r1 + GPIO_GPPUDCLK0)

	mov r0,150
	bl  delay

	mov r0, 0
	st  r0, (r1 + GPIO_GPPUDCLK0)

	;; Set up serial port
	mov r2, 1
	mov r1, UART1_BASE
	st  r2, (r1 + UART_AUX_ENABLES)
	mov r2, 0x43
	st  r0, (r1 + UART_AUX_MU_IER_REG)
	st  r0, (r1 + UART_AUX_MU_CNTL_REG)
	st  r2, (r1 + UART_AUX_MU_LCR_REG)
	mov r2, 0xc6
	st  r0, (r1 + UART_AUX_MU_MCR_REG)
	st  r0, (r1 + UART_AUX_MU_IER_REG)
	st  r2, (r1 + UART_AUX_MU_IIR_REG)
	add r0, r3, -1
	mov r2, 3
	st  r0, (r1 + UART_AUX_MU_BAUD_REG)
	st  r2, (r1 + UART_AUX_MU_CNTL_REG)

	;; keep TX low for two bits before returning to the caller,
	;; so our serial connection peer can detect a framing error
	;; and recover the start of the next frame if a transmission
	;; was interrupted
	shl r0, r3, 4
	bl  delay
	st  r2, (r1 + UART_AUX_MU_LCR_REG)

	ldm pc,(sp++)
