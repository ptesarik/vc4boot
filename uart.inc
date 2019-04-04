
;;; System clock is running directly off the 19.2MHz crystal at initial reset
SYSTEM_CLOCK = 19200000

;;; Because of the low system clock rate, this baud rate might be inaccurate
;;; So be careful with your serial/terminal, some adjustment may be necessary.
.ifdef TURBO_SERIAL
TARGET_BAUD_RATE = 1200000
.else
TARGET_BAUD_RATE = 115200
.endif
