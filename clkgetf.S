;;;
;;; Get clock frequency
;;;

.include "mmio.inc"

	.text

;;; r0 ... offset to the Clock Manager control register
;;;        (e.g. CM_VPUCTL)
;;; Returns: clock frequency in Hz
;;;
	.global clk_get_freq
clk_get_freq:
	mov  r1, A2W_BASE
	add  r0, CM_BASE
	ld   r2, (r0 + 4)	; xxx_DIV register
	beq  r2, 0, L_gnd
	fltu r2, r2, sasr 12

	;; floating point divisor is in r2, now determine base rate:
	ld  r3, (r0)		; xxx_CTL register
	bmask r3, 3
	bgt  r3, 9, L_unk_source
	switch r3
1:
	.case L_gnd - 1b	; GND
	.case L_xosc - 1b	; XOSC
	.case L_unk_source - 1b ; TESTDEBUG0
	.case L_unk_source - 1b ; TESTDEBUG1
	.case L_plla - 1b	; PLLA_CORE
	.case L_pllc0 - 1b	; PLLC_CORE0
	.case L_plld - 1b	; PLLD_CORE
	.case L_pllh - 1b	; PLLH_AUX
	.case L_pllc1 - 1b	; PLLC_CORE1
	.case L_pllc2 - 1b	; PLLC_CORE2
	.endswitch

L_xosc:
	mov   r0, 0x4b927c00	; 19.2 * 10^6
	fdiv  r0, r0, r2
	floor r0, r0, sasl0
	rts

L_plla:
	ld  r0, (r1 + A2W_PLLA_CORE)
	ld  r3, (r1 + A2W_PLLA_ANA1)
	ld  r4, (r1 + A2W_PLLA_CTRL)
	ld  r5, (r1 + A2W_PLLA_FRAC)
	btest r3, 14
	b   L_pll

L_plld:
	ld  r0, (r1 + A2W_PLLD_CORE)
	ld  r3, (r1 + A2W_PLLD_ANA1)
	ld  r4, (r1 + A2W_PLLD_CTRL)
	ld  r5, (r1 + A2W_PLLD_FRAC)
	btest r3, 14
	b   L_pll

L_pllh:
	ld  r0, (r1 + A2W_PLLH_AUX)
	ld  r3, (r1 + A2W_PLLH_ANA1)
	ld  r4, (r1 + A2W_PLLH_CTRL)
	ld  r5, (r1 + A2W_PLLH_FRAC)
	btest r3, 11
	bic r4, 0x300		; PLLH ndiv is only 8 bits
	b   L_pll

L_pllc2:
	ld  r0, (r1 + A2W_PLLC_CORE2)
	b   L_pllc
L_pllc1:
	ld  r0, (r1 + A2W_PLLC_CORE1)
	b   L_pllc
L_pllc0:
	ld  r0, (r1 + A2W_PLLC_CORE0)
L_pllc:
	ld  r3, (r1 + A2W_PLLC_ANA1)
	ld  r4, (r1 + A2W_PLLC_CTRL)
	ld  r5, (r1 + A2W_PLLC_FRAC)
	btest r3, 14
L_pll:
	;; combine PLL integer and fractional parts
	bmask r3, r4, 10	; integer part (ndiv)
	shl.ne r3, r3, 1	; prediv (ANA1)
	bmask r5, 20
	shl.ne r5, r5, 1	; prediv (ANA1)
	fltu  r5, r5, sasr 20	; fractional part (fdiv)
	fltu  r3, r3, sasr 0
	fadd  r5, r5, r3

	;; apply pre-divider
	lsr   r4, 12		; pre-divider (pdiv)
	bmask r4, 3
	beq   r4, 0, L_gnd
	fltu  r4, r4, sasr 0
	fdiv  r5, r5, r4

	;; adjust accumulated divider by PLL divider
	bmask r0, 8
	fltu r0, r0, sasr 0
	fmul r2, r2, r0

	;; calculate base VCO rate
	mov   r0, 0x4b927c00	; 19.2 * 10^6
	fmul  r5, r0, r5

	;; apply cumulated clock divider
	fdiv  r0, r5, r2

	;; convert to integer
	floor r0, r0, sasl0
	rts

L_unk_source:
	;; unknown clock source, nothing we can handle
L_gnd:
	mov  r0, 0
	rts
