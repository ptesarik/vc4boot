;;;
;;; memcpy
;;;

	.text

	.global memcpy
memcpy:
	;; r0 ... target memory area
	;; r1 ... source memory area
	;; r2 ... number of bytes

	;; do not bother with words/halfs if less than 4 bytes
	blo r2, 4, .L_bytes

	;; check 4-byte alignment
	or  r3, r1, r0
	bmask r4, r3, 2
	bne r4, 0, .L_no_words

	;; copy words until n < 4
.L_words_loop:
	ld  r3, (r1++)
	st  r3, (r0++)
	addcmpbhs r2, -4, 4, .L_words_loop

.L_no_words:
	;; check 2-byte alignment
	btest r4, 0
	bne .L_bytes

	;; copy shorts until n < 2
	blo r2, 2, .L_bytes
.L_shorts_loop:
	ldh r3, (r1++)
	sth r3, (r0++)
	addcmpbhs r2, -2, 2, .L_shorts_loop

	;; copy bytes until n == 0
.L_bytes:
	beq r2, 0, .L_done
.L_bytes_loop:
	ldb r3, (r1++)
	stb r3, (r0++)
	addcmpbne r2, -1, 0, .L_bytes_loop
.L_done:
	rts
