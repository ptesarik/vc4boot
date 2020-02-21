;;;
;;; Program OTP memory
;;;
;;; This program works ONLY with RPi4.
;;;

.include "mmio.inc"
.include "uart.inc"

;;; Change to the desired OTP register number:
OTP_REG = 36
;;; Change to the new value that should be programmed:
OTP_NEW_VAL = 0x20

	.text
	.org 0x200

	.global _start
_start:
	mov r0, CM_VPUCTL
	bl  clk_get_freq
	mov r6, r0
	bl  uart_init

	lea r0, txt_hline
	bl  uart_puts

	bl  otp_open

	mov r0, OTP_REG
	bl  otp_read_reg
	cmp r0, -1
	mov r6, r0
	beq err_all_set

	lea r0, txt_old_value
	bl  uart_puts
	mov r0, r6
	bl  uart_puthexword
	bl  uart_putcrlf

	bl  otp_enable_program
	bne r0, 0, err_enable

	mov r0, OTP_REG
	mov r1, OTP_NEW_VAL
	bl  otp_write_reg
	bne r0, 0, err_program

	bl  otp_disable_program
	bne r0, 0, err_disable

	bl  otp_close

print_new_value:
	lea r0, txt_new_value
	bl  uart_puts

	bl  otp_open
	mov r0, OTP_REG
	bl  otp_read_reg
	bl  uart_puthexword
	bl  uart_putcrlf
	bl  otp_close

	b   led_flash

err_all_set:
	lea r0, txt_err_all_set
	b   error
err_enable:
	lea r0, txt_err_enable
	b   error
err_program:
	lea r0, txt_err_program
	b   error
err_disable:
	;; the bit is probably programmed anyway
	lea r0, txt_err_disable
error:
	bl  uart_puts
	b   print_new_value


txt_hline:
	.asciz "--------------------\r\n"

txt_old_value:
	.asciz "Old OTP register value: "
txt_new_value:
	.asciz "New OTP register value: "

txt_err_all_set:
	.asciz "All bits are already programmed!\r\n"
txt_err_enable:
	.asciz "Cannot enable OTP programming. :-(\r\n"
txt_err_program:
	.asciz "Programming command failed.\r\n"
txt_err_disable:
	.asciz "Cannot disable OTP programming.\r\n"

	.balign 2
