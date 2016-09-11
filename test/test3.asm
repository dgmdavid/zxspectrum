
	org 08000h

begin:
	ld hl,$4000
	ld a,(posx)
	add a,l
	ld l,a
	cp %0010000
	jr NZ,skip
	ld a,h
	or %00011111
	add a,128
	ld h,a
	set 6,h
skip:
	inc a
	ld (posx),a
	ld de,sprite
	ld b,8

loop:
	ld a,(de)
	ld (hl),a
	inc de
	inc h
	dec b
	jr NZ,loop

	jp begin

	ret

posx:
	db 0

sprite:
       db %11111111
       db %10000001
       db %10111101
       db %10100101
       db %10100101
       db %10111101
       db %10000001
       db %11111111

	end 08000h