
;;;
;;; GPIO MMIO
;;;
	GPIO_BASE = 0x7e200000
GPIO_GPFSEL0   = 0x00		; Function Select 0
GPIO_GPFSEL1   = 0x04		; Function Select 1
GPIO_GPFSEL2   = 0x08		; Function Select 2
GPIO_GPFSEL2   = 0x0c		; Function Select 3
GPIO_GPFSEL2   = 0x10		; Function Select 4
GPIO_GPFSEL2   = 0x14		; Function Select 5
GPIO_GPSET0    = 0x1c		; Pin Output Set 0
GPIO_GPSET1    = 0x20		; Pin Output Set 1
GPIO_GPCLR0    = 0x28		; Pin Output Clear 0
GPIO_GPCLR1    = 0x2c		; Pin Output Clear 1
GPIO_GPLEV0    = 0x34		; Pin Level 0
GPIO_GPLEV1    = 0x38		; Pin Level 1
GPIO_GPEDS0    = 0x40		; Pin Event Detect Status 0
GPIO_GPEDS1    = 0x44		; Pin Event Detect Status 1
GPIO_GPREN0    = 0x4c		; Pin Rising Edge Detect Enable 0
GPIO_GPREN1    = 0x50		; Pin Rising Edge Detect Enable 1
GPIO_GPFEN0    = 0x58		; Pin Falling Edge Detect Enable 0
GPIO_GPFEN1    = 0x5c		; Pin Falling Edge Detect Enable 1
GPIO_GPHEN0    = 0x64		; Pin High Detect Enable 0
GPIO_GPHEN1    = 0x68		; Pin High Detect Enable 1
GPIO_GPLEN0    = 0x70		; Pin Low Detect Enable 0
GPIO_GPLEN1    = 0x74		; Pin Low Detect Enable 1
GPIO_GPAREN0   = 0x7c		; Pin Async Rising Edge Detect 0
GPIO_GPAREN1   = 0x80		; Pin Async Rising Edge Detect 1
GPIO_GPAFEN0   = 0x88		; Pin Async Falling Edge Detect 0
GPIO_GPAFEN1   = 0x8c		; Pin Async Falling Edge Detect 1
GPIO_GPPUD     = 0x94		; Pin Pull-up/down Enable
GPIO_GPPUDCLK0 = 0x98		; Pin Pull-up/down Enable Clock 0
GPIO_GPPUDCLK0 = 0x9c		; Pin Pull-up/down Enable Clock 1

;;;
;;; UART1 MMIO
;;;
	UART1_BASE = 0x7e215000
UART_AUX_IRQ         = 0x00
UART_AUX_ENABLES     = 0x04
UART_AUX_MU_IO_REG   = 0x40
UART_AUX_MU_IER_REG  = 0x44
UART_AUX_MU_IIR_REG  = 0x48
UART_AUX_MU_LCR_REG  = 0x4C
UART_AUX_MU_MCR_REG  = 0x50
UART_AUX_MU_LSR_REG  = 0x54
UART_AUX_MU_MSR_REG  = 0x58
UART_AUX_MU_SCRATCH  = 0x5C
UART_AUX_MU_CNTL_REG = 0x60
UART_AUX_MU_STAT_REG = 0x64
UART_AUX_MU_BAUD_REG = 0x68
