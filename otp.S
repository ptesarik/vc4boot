;;;
;;; UART
;;;

.include "mmio.inc"

	.text

	.global otp_open
otp_open:
	stm lr, (--sp)
	mov r2, 0x03
	mov r1, OTP_BASE
	mov r3, A2W_BASE + A2W_XOSC0
	st  r2, (r1 + OTP_CONFIG_REG)

	mov r0, 2
1:
	ld  r2, (r3)
	addcmpbge r0, -1, 0, 1b

	mov r2, 0
	st  r2, (r1 + OTP_CTRL_HI_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)

	mov r0, 2
1:
	ld  r2, (r3)
	addcmpbge r0, -1, 0, 1b

	mov r2, 0x02
	st  r2, (r1 + OTP_CONFIG_REG)
	ldm pc, (sp++)

	.global otp_read_reg
otp_read_reg:
	stm lr, (--sp)
	mov r1, OTP_BASE
	mov r3, A2W_BASE + A2W_XOSC0
	st  r0, (r1 + OTP_ADDR_REG)

	mov r0, 2
1:
	ld  r2, (r3)
	addcmpbge r0, -1, 0, 1b

	mov r2, 0
	ld  r0, (r1 + OTP_ADDR_REG)
	st  r2, (r1 + OTP_CTRL_HI_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)

	mov r0, 2
1:
	ld  r2, (r3)
	addcmpbge r0, -1, 0, 1b

	mov r2, 1
	ld  r0, (r1 + OTP_CTRL_LO_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)
	ld  r0, (r1 + OTP_CTRL_LO_REG)
1:
	mov r0, 2
2:
	ld  r2, (r3)
	addcmpbge r0, -1, 0, 2b

	ld  r0, (r1 + OTP_STATUS_REG)
	btest r0, 0
	beq  1b
	ld   r0, (r1 + OTP_DATA_REG)
	ldm  pc, (sp++)

	.global otp_close
otp_close:
	stm lr, (--sp)
	mov r2, 0
	mov r1, OTP_BASE
	mov r3, A2W_BASE + A2W_XOSC0
	st  r2, (r1 + OTP_CTRL_HI_REG)
	st  r2, (r1 + OTP_CTRL_LO_REG)

	mov r0, 2
1:
	ld  r2, (r3)
	addcmpbge r0, -1, 0, 1b

	st  r2, (r1 + OTP_CONFIG_REG)
	ldm pc, (sp++)
