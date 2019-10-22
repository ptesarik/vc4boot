;;;
;;; Led flasher
;;;

.include "mmio.inc"

	.global led_flash
led_flash:
	mov r1, GPIO_BASE
	mov r2, 0x00010000

	ld  r0, (r1 + GPIO_GPFSEL1)
	and r0, ~(7<<18)
	or  r0, (1<<18)
	st  r0, (r1 + GPIO_GPFSEL1)

.L_flash_loop:
	st  r2, (r1 + GPIO_GPSET0)

	mov r0, 0x00100000
	bl  delay

	st  r2, (r1 + GPIO_GPCLR0)

	mov r0, 0x00100000
	bl  delay
	b .L_flash_loop
