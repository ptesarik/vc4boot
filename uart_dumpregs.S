.include "mmio.inc"
.include "uart.inc"

;;; Register dump should be called like this:
;;;
;;;   	stm r0-pc, (--sp)
;;; 	bl  uart_dumpregs
;;;     add sp, 32*4
;;;

	.global uart_dumpregs
uart_dumpregs:
	stm r6-r8, lr, (--sp)

	mov r6, 32
	add r7, sp, 4*36
	lea r8, .L_regnames

.L_loop:
	;; register name and colon
	ld  r0, (r8++)
	bl  uart_putchars
	mov r0, ':' | ' ' << 8
	bl  uart_putchars

	;; register value
	ld  r0, (--r7)
	bl  uart_puthexword

	;; space or newline
	bmask r1, r6, 2
	mov r0, '\r' << 8 | '\n'
	beq r1, 1, 1f
	mov r0, ' '
1:
	bl  uart_putchars

	addcmpbne r6, -1, 0, .L_loop

	ldm r6-r8, pc, (sp++)

	.data

	.align 4
.L_regnames:
	.asciz " r0"
	.asciz " r1"
	.asciz " r2"
	.asciz " r3"
	.asciz " r4"
	.asciz " r5"
	.asciz " r6"
	.asciz " r7"
	.asciz " r8"
	.asciz " r9"
	.asciz "r10"
	.asciz "r11"
	.asciz "r12"
	.asciz "r13"
	.asciz "r14"
	.asciz "r15"
	.asciz "r16"
	.asciz "r17"
	.asciz "r18"
	.asciz "r19"
	.asciz "r20"
	.asciz "r21"
	.asciz "r22"
	.asciz "r23"
	.asciz " gp"
	.asciz " sp"
	.asciz " lr"
	.asciz "r27"
	.asciz "r28"
	.asciz "r29"
	.asciz " sr"
	.asciz " pc"
