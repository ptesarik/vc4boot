;;;
;;; Dump the contents of OTP memory (hex)
;;;

.include "mmio.inc"

	.text
	.org 0x200

	.global _start
_start:
	bl uart_init

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

otp_open:
	stm lr, (--sp)
	mov r2, 0x03
	mov r1, OTP_BASE
	st  r2, (r1 + OTP_CONFIG_REG)
	mov r0, 20
	bl  delay
	mov r2, 0
	st  r2, (r1 + OTP_CTRL_HI_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)
	mov r0, 20
	bl  delay
	mov r2, 0x02
	st  r2, (r1 + OTP_CONFIG_REG)
	mov r0, 20
	bl  delay
	ldm pc, (sp++)

otp_read_reg:
	stm lr, (--sp)
	mov r1, OTP_BASE
	st  r0, (r1 + OTP_ADDR_REG)
	mov r0, 20
	bl  delay
	mov r2, 0
	ld  r0, (r1 + OTP_ADDR_REG)
	st  r2, (r1 + OTP_CTRL_HI_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)
	mov r0, 40
	bl  delay
	mov r2, 1
	ld  r0, (r1 + OTP_CTRL_LO_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)
	ld  r0, (r1 + OTP_CTRL_LO_REG)
1:
	mov r0, 20
	bl  delay
	ld  r0, (r1 + OTP_STATUS_REG)
	btest r0, 0
	beq  1b
	ld   r0, (r1 + OTP_DATA_REG)
	ldm  pc, (sp++)

otp_close:
	stm lr, (--sp)
	mov r2, 0
	mov r1, OTP_BASE
	st  r2, (r1 + OTP_CTRL_HI_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)
	mov r0, 20
	bl  delay
	st  r2, (r1 + OTP_CONFIG_REG)
	ldm pc, (sp++)
