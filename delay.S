;;;
;;; Simple busy wait
;;;
;;;   r0 ... number of VPU cycles / 2
;;; Guaranteed to clobber no registers except argument r0.
;;; Always returns zero (success) in r0.
;;;
	.global delay
delay:
1:
	nop
	addcmpbne r0, -1, 0, 1b
	rts
