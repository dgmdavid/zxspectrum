;
; Video related constants
;

SCREEN_MEM      equ $4000
SCREEN_MEM_SIZE equ 6144

COLOUR_MEM      equ $5800
COLOUR_MEM_SIZE equ 768

; set temporary color (ROM)
TEMP_COLOUR_ADDR equ 23695

; foreground/ink colours
INK_BLACK   equ %00000000
INK_BLUE    equ %00000001
INK_RED     equ %00000010
INK_MAGENTA equ %00000011
INK_GREEN   equ %00000100
INK_CYAN    equ %00000101
INK_YELLOW  equ %00000110
INK_WHITE   equ %00000111

; background/paper colours
BG_BLACK    equ %00000000
BG_BLUE     equ %00001000
BG_RED      equ %00010000
BG_MAGENTA  equ %00011000
BG_GREEN    equ %00100000
BG_CYAN     equ %00101000
BG_YELLOW   equ %00110000
BG_WHITE    equ %00111000

; colour properties
COLOUR_BRIGHT equ %01000000
COLOUR_FLASH  equ %10000000

;eof