;;;
;;; memset
;;;

	.text

	.global memset
memset:
	;; r0 ... target memory area
	;; r1 ... fill value
	;; r2 ... number of bytes

	;; do not bother with words unless you can be sure that the
	;; loop gets executed at least once even if r0 is unaligned
	blo   r2, 8, L_set_bytes

	bmask r3, r0, 2
	beq   r3, 0, L_set_words

	;; store bytes until r0 is word-aligned
	sub   r2, 4
	add   r2, r3
L_align_loop:
	stb   r1, (r0++)
	addcmpbne r3, 1, 4, L_align_loop

L_set_words:
	;; repeat fill value in all bytes of r1
	bmask r1, 8
	shl   r3, r1, 8
	or    r3, r1
	shl   r1, r3, 16
	or    r1, r3

	;; store words
	lsr   r3, r2, 2
L_words_loop:
	st    r1, (r0++)
	addcmpbne r3, -1, 0, L_words_loop

	;; remaining bytes
	bmask r2, 2

L_set_bytes:
	beq   r2, 0, L_done
L_bytes_loop:
	stb   r1, (r0++)
	addcmpbne r2, -1, 0, L_bytes_loop
L_done:
	rts
