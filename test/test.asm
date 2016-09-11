;
; ZX Spectrum Memory Map
;
; $0000 - $3FFF - ROM
; $4000 - $57FF - Screen Memory
; $5800 - $5AFF - Screnn Memory (Colour Data)
; $5B00 - $5BFF - Printer Buffer
; $5C00 - $5CBF - System Variables
; $5CC0 - $5CCA - Reserved
; $5CCB - $FF57 - Available Memory (PROG and RAMTOP)
; $FF58 - $FFFF - Reserved
;

;
; ZX Spectrum Screen Addressing
;
; 010TTLLL - RRRCCCCC
; T: 0-03 screen third
; L: 0-07 "character line" (screen lines relative to char line)
; R: 0-07 char line (8 pixels vertical)
; C: 0-31 char column (8 pixels horizontal)
;

	org 08000h
	jp start

      include "lib/video_constants.asm"
      include "lib/video_screen.asm"

dire    db 0
posy    db 0
posx    db 0

start:
	call ClearScreen
	SetTempColour INK_GREEN+BG_WHITE
	PrintChar 'D'
	PrintStringAt 5,0,string,string_size
cu:
	jp cu

loop:
	halt
	;call Clear_Screen_Fast

	ld a,(posx)
	ld b,a
	ld a,(posy)
	ld c,a
	ld de,sprite
	call draw_1x1_sprite
	;call draw_1x1_sprite_buffer
	ld a,(posx)
	inc a
	ld (posx),a
	cp 31
	jp Z,skip1
	jp loop
skip1:
	xor a
	ld (posx),a
	ld a,(posy)
	inc a
	cp 23
	jp Z,end_test
	ld (posy),a
	jp loop
	; animate position
;	ld a,(dire)
;	cp 0
;	jp Z,incre
;	ld a,(posy)
;	dec a
;	ld (posy),a
;	cp 0
;	jp NZ,after
;	ld a,0
;	ld (dire),a
;	jp after
;incre:
;	ld a,(posy)
;	inc a
;	ld (posy),a
;	cp 23
;	jp NZ,after
;	ld a,1
;	ld (dire),a

after:
	jp loop

end_test:
	xor a
	ld (posx),a
	ld (posy),a
	ld (dire),a
	;jp loop
	;jp end_test

	ld a,100
wait2:
	halt
	dec a
	jp NZ,wait2

another:
	halt
	ld hl,$4000
	ld bc,6144
an_loop:
	ld a,(hl)
 	bit 0,c
	jp Z,an_skip
	;rra
	rrc a
	jp an_skip2
an_skip:
	;rla
	rlc a
an_skip2:
	ld (hl),a
	inc hl
	dec bc
	ld a,b
	or c
	jp NZ,an_loop

	jp another

	ret

string db "PRESS ENTER"
string_size equ $-string

; 1x1 Sprite
; de - sprite address
; b,c - x,y (32x24)
draw_1x1_sprite:
	; is x greater than 31?
	ld a,b
	cp 32
	jr NC,end_draw_1x1_sprite
	; is y greater than 23?
	ld a,c
	cp 24
	jp NC,end_draw_1x1_sprite
	; calculate screen address
	ld l,b	; set x
	ld a,c
	and %00011000
	or %01000000
	ld h,a ; set y (screen third)
	ld a,c
	and %00000111
	rla
	rla
	rla
	rla
	rla
	or l
	ld l,a
	; copy 8 lines
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
end_draw_1x1_sprite:
	ret

draw_1x1_sprite_buffer:
	; is x greater than 31?
	ld a,b
	cp 255
	jr NC,end_draw_1x1_sprite_buffer
	; is y greater than 23?
	ld a,c
	cp 191
	jp NC,end_draw_1x1_sprite_buffer
	; calculate screen address
	ld hl,BLANK_SCREEN
	ld a,b
	rla
	rla
	rla
	ld b,a
	ld a,h
;	add b
	ld h,a	; set x
	ld a,c
	rra
	rra
	rra
	ld l,a ; set y
	; copy 8 lines
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
	inc h
	inc e
	ld a,(de)
	ld (hl),a
end_draw_1x1_sprite_buffer:
	ret

sprite:
	db %11111111
	db %10000001
	db %10111101
	db %10100101
	db %10100101
	db %10111101
	db %10000001
	db %11111111

BLANK_SCREEN: DS 7000,%00011000

	end 08000h
