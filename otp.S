;;;
;;; UART
;;;

.include "mmio.inc"

OTP_MAX_WAIT	= 10000

	.text

;;; delay between two accesses to the same OTP register (?)
;;;
;;; This is a small delay to make sure register writes are
;;; propagated to the OTP.
;;;
;;; The OTP probably has an edge-triggered latch for its hardware
;;; registers. Apparently, the OTP takes its clock directly from
;;; the oscillator.
;;;
;;; FIXME: There is some more magic involved. Waiting until the next
;;; oscillator tick is not enough. I have tested with 100 VPU cycles
;;; at 500 MHz (0.2 us), but it could be just my piece of hardware...
;;; A good safe value should be determined.
;;;
;;; FWIW the OCOTP Linux driver 1 us, but that's most likely because
;;; udelay() cannot wait less than that.
;;;
;;; Guaranteed to clobber no registers except r0.
;;; Always returns zero (success) in r0.
	.global otp_delay
otp_delay:
	mov r0, 50
	b   delay

;;; enable OTP operation and reset its state
	.global otp_open
otp_open:
	mov r5, lr
	mov r1, OTP_BASE

	;; TODO: Is this really needed? The code seems to work
	;; without this block, at least on BCM2711 B0 silicon.
	mov r0, 0x03
	st  r0, (r1 + OTP_CONFIG_REG)
	bl  otp_delay

	mov r2, 0x02
	st  r0, (r1 + OTP_CTRL_HI_REG)
	st  r0, (r1 + OTP_CTRL_LO_REG)
	st  r0, (r1 + OTP_ADDR_REG)
	st  r0, (r1 + OTP_DATA_REG)
	st  r2, (r1 + OTP_CONFIG_REG)

	b   r5			; r5 is saved lr

;;; disable OTP operation
	.global otp_close
otp_close:
	mov r1, OTP_BASE
	mov r0, 0
	st  r0, (r1 + OTP_CTRL_HI_REG)
	st  r0, (r1 + OTP_CTRL_LO_REG)
	st  r0, (r1 + OTP_CONFIG_REG)
	rts

;;; set OTP control regs
;;;   r0 ... OTP_CTRL_LO_REG
;;;   r1 ... OTP_CTRL_HI_REG
	.global otp_set_command
otp_set_command:
	mov r5, lr
	mov r4, OTP_BASE
	bitset r2, r0, 0	; OTP_CMD_START (?)

	st  r1, (r4 + OTP_CTRL_HI_REG)
	st  r0, (r4 + OTP_CTRL_LO_REG)

	;; wait until ready
	mov r3, OTP_MAX_WAIT
1:
	bl  otp_delay
	ld  r0, (r4 + OTP_STATUS_REG)
	btest r0, OTP_STAT_CMD_DONE_BIT
	bne 2f
	addcmpbgt r3, -1, 0, 1b
	b   3f
2:

	;; set OTP_CMD_START (see above)
	st  r2, (r4 + OTP_CTRL_LO_REG)

	;; wait until ready
	mov r3, OTP_MAX_WAIT
1:
	bl  otp_delay
	ld  r1, (r4 + OTP_STATUS_REG)
	btest r1, OTP_STAT_CMD_DONE_BIT
	bne 2f
	addcmpbgt r3, -1, 0, 1b

	;; error path: return -1
3:
	not r0, 0
2:
	b   r5			; r5 is saved lr

	.global otp_read_reg
otp_read_reg:
	stm lr, (--sp)

	mov r1, OTP_BASE + OTP_ADDR_REG
	st  r0, (r1)

	mov r0, 0		; OTP_CMD_READ << 1 (?)
	mov r1, 0
	bl  otp_set_command
	bne r0, 0, 1f

	mov r1, OTP_BASE + OTP_DATA_REG
	ld  r0, (r1)
1:
	ldm pc, (sp++)
