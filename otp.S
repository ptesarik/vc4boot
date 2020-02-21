;;;
;;; UART
;;;

.include "mmio.inc"

OTP_MAX_WAIT	= 1000

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
;;; Knowing that the oscillator ticks at 54.0 MHz (or 19.2 MHz
;;; on the RPi3) and the VPU runs at 600 MHz max, the access can
;;; be replaced with a delay of 600/19.2 = 31.25 VPU ticks.
;;;
;;; One catch is that we do not know whether the VPU can execute
;;; multiple instructions simultaneously, but let's assume that
;;; one execution of a loop takes at least 1 cycle, and the call
;;; overhead another two. This is how I figured out the "magic"
;;; number 30 below.
;;;
;;; Guaranteed to clobber no registers except r0.
;;; Always returns zero (success) in r0.
	.global otp_delay
otp_delay:
	mov r0, 30
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
