;;;
;;; Simple busy wait
;;;
;;; Guaranteed to clobber no registers except argument r0.
;;; Always returns zero (success) in r0.
;;;

	.global delay
delay:
	nop
	add r0, r0, -1
	cmp r0, 0
	bne delay
	rts
