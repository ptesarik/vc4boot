;;;
;;; OTP write support
;;;
;;; !!! DISCLAIMER !!!
;;; These routines have been tested on BCM2711 B0 silicon ONLY.
;;; They most likely do not work with BCM283x, and they may not
;;; even work with another revision of the BCM2711 silicon.
;;;
;;; You have been warned...

.include "mmio.inc"

OTP_MAX_WAIT	= 32000

	.text

;;; Enable programming of the OTP
	.global otp_enable_program
otp_enable_program:
	stm r6-r8, lr, (--sp)
	lea r8, OTP_PROG_EN_SEQ
	mov r7, OTP_BASE
	mov r6, 4

	;; write the magic sequence to enable programming
1:
	ld  r0, (r8++)
	st  r0, (r7 + OTP_DATA_REG)
	mov r0, 0x4		; OTP_CMD_OTP_PROG_ENABLE << 1 (?)
	mov r1, 0x0		; ctrl hi
	bl  otp_set_command
	bne r0, 0, 3f		; break if otp_set_command failed
	addcmpbgt r6, -1, 0, 1b

	;; wait for status bit 2 (max 32000 attempts)
	mov r6, 32000
	mov r2, 0
2:
	mov r0, 30
	bl  delay
	ld  r1, (r7 + OTP_STATUS_REG)
	btest r1, 2		; OTP_STAT_PROG_OK (?)
	bne 4f
	addcmpbgt r6, -1, 0, 2b
3:
	not r0, 0
4:
	ldm r6-r8, pc, (sp++)

;;; Disable programming of the OTP
	.global otp_disable_program
otp_disable_program:
	mov r0, 0x6		; OTP_CMD_OTP_PROG_DISABLE << 1 (?)
	mov r1, 0
	b   otp_set_command

;;; This magic sequence is taken from the Broadcom OTP Linux driver
;;; (drivers/nvmem/bcm-ocotp.c).
	.balign 4
OTP_PROG_EN_SEQ:
	.long 0xf, 0x4, 0x8, 0xd

;;; Write a new value to an OTP register
;;;   r0 ... register address
;;;   r1 ... desired new value
	.global otp_write_reg
otp_write_reg:
	stm r6-r7, lr, (--sp)
	mov r6, r0
	mov r7, r1
	bl  otp_read_reg

	;; Set new value
	or  r0, r7
	mov r7, OTP_BASE
	st  r0, (r7 + OTP_DATA_REG)
	bl  otp_delay

	;; Set up address (register number)
	st  r6, (r7 + OTP_ADDR_REG)
	bl  otp_delay

	mov r0, 0x14		; OTP_CMD_PROGRAM_WORD << 1 (?)
	mov r1, 0
	bl  otp_set_command

	ldm r6-r7, pc, (sp++)
