;;;
;;; Get VPU info
;;;

.include "mmio.inc"

	.text
	.org 0x200

	.global _start
_start:
	mov r0, CM_VPUCTL
	bl  clk_get_freq
	mov r6, r0

	bl uart_init

	;; VPU ID
	lea r0, txt_vpuid
	bl  uart_puts
	version r0
	bl  uart_puthexword
	bl  uart_putcrlf

	;; VPU rate
	lea r0, txt_vpufreq
	bl  uart_puts
	mov r0, r6
	bl  uart_putdecword
	lea r0, txt_hz
	bl  uart_puts

	;; Dump OTP memory
	lea r0, txt_otpdump
	bl  uart_puts

	bl  otp_open
	mov r6, 0		; OTP register address
	mov r7, 127
.L_otp_loop:
	mov r0, r6
	bl  uart_putdecword

	mov r0, r6
	bl  otp_read_reg
	mov r8, r0

	mov r0, ':' <<0 | ' ' <<8
	bl  uart_putchars

	mov r0, r8
	bl  uart_puthexword
	bl  uart_putcrlf

	addcmpbls r6, 1, r7, .L_otp_loop

	bl  otp_close

	b   led_flash

txt_vpufreq:	.asciz "VPU runs at "
txt_hz:		.asciz " Hz\r\n"

txt_vpuid:	.asciz "VPU ID: 0x"

txt_otpdump:	.asciz "OTP memory dump: \r\n"

	.align 2
