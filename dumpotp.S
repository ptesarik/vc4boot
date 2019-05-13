;;;
;;; Dump the contents of OTP memory (hex)
;;;

.include "mmio.inc"

	.text
	.org 0x200

	.global _start
_start:
	mov r0, CM_VPUCTL
	bl  clk_get_freq
	bl uart_init

	mov r6, OTP_BASE
	lea r0, txt_bootmode
	bl  uart_puts
	ld  r0, (r6)		; OTP_BOOTMODE_REG
	bl  uart_puthexword
	bl  uart_putcrlf

	mov r6, 0		; OTP register address

loop_reg:
	mov r0, 'R' <<0 | 'E' <<8 | 'G' <<16 | ' ' <<24
	bl  uart_putchars

	mov r0, r6
	bl  uart_puthexword

	bl  otp_open
	mov r0, r6
	bl  otp_read_reg
	mov r7, r0
	bl  otp_close

	mov r0, ':' <<0 | ' ' <<8
	bl  uart_putchars

	mov r0, r7
	bl  uart_puthexword
	bl  uart_putcrlf

	add r6, 1
	cmp r6, 127
	bls loop_reg

	b   led_flash

txt_bootmode:
	.asciz "BOOTMODE: "

	.align 2
