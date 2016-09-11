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
      include "lib/video_sprite_1x1.asm"
      include "lib/video_sprite_2x2.asm"

dire    db 0
posy    db 0
posx    db 0

start:
	call ClearScreen
	
	ld b,0
	ld c,0
	ld de,sprite3
	call Draw2x2Sprite
cuu:	jp cuu


	SetTempColour INK_GREEN+BG_WHITE
	PrintStringAt 5,0,string,string_size+20

	ld hl,COLOUR_MEM
	ld de,400
	ld bc,COLOUR_MEM_SIZE
oi:
	ld a,(de)
	and %00011000
	or %00000111
	ld a,INK_GREEN|BG_BLACK
	ld (hl),a
	inc hl
	inc de
	dec bc
	ld a,b
	or c
	jp nz,oi

loop:
	ld a,(dire)
	cp 0
	jp z,oioioi
	ld de,sprite
	jp draw
oioioi:
	ld de,sprite2
draw:
	ld a,(posx)
	ld b,a
	ld a,(posy)
	ld c,a
	call Draw1x1Sprite
	ld a,(posx)
	inc a
	ld (posx),a
	cp 32
	jp Z,skip1
	jp loop
skip1:
	xor a
	ld (posx),a
	ld a,(posy)
	inc a
	cp 24
	jp Z,after;end_test
	ld (posy),a
	jp loop

after:
	halt
	xor a
	ld (posx),a
	ld (posy),a

	ld a,(dire)
	cp 0
	jp z,outro
	ld a,0
	ld (dire),a
	jp loop
outro:
	ld a,1
	ld (dire),a
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
	;ld hl,BLANK_SCREEN
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
sprite2:
	db %00000000
	db %01111110
	db %01000010
	db %01011010
	db %01011010
	db %01000010
	db %01111110
	db %00000000

sprite3:
	db %11111111,%11111111
	db %10000000,%00000001
	db %10111111,%11111101
	db %10100000,%00000101
	db %10101111,%11110101
	db %10101111,%11110101
	db %10101100,%00110101
	db %10101100,%00110101
	db %10101100,%00110101
	db %10101100,%00110101
	db %10101111,%11110101
	db %10101111,%11110101
	db %10100000,%00000101
	db %10111111,%11111101
	db %10000000,%00000001
	db %11111111,%11111111

	end 08000h
