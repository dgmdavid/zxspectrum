;--------------------------------------------------------------------------------
; aracno.asm
;
; Aracnophobia
;
; 17/09/2016
; by dgm
;--------------------------------------------------------------------------------

	org $8000
	call ClearScreen

	ld a,4
	ld (tmp),a
	ld a,spider_count
loop:
	push af
	ld a,(tmp)
	ld b,a
	ld c,0
	ld de,spider1
	call Draw2x2Sprite
	ld a,(tmp)
	add a,2
	ld (tmp),a
	pop af
	dec a
	jp nz,loop

outro:
	; move a spider
	ld b,0
	ld a,(spider_index)
	ld c,a
	ld ix,spiders_pos
	add ix,bc
	ld b,(ix)
	push bc
	call random_speed
	pop bc
	add a,b
	ld (ix),a
	sra a
	sra a
	sra a
	ld c,a
	ld b,4
	ld a,(spider_index)
	add a,a
	add a,b
	ld b,a
	ld de,spider1
	call Draw2x2Sprite

	ld a,(spider_index)
	inc a
	cp spider_count
	jp nz,skip1
	xor a
skip1:
	ld (spider_index),a
	halt
	jp outro

ee:
	jp ee

; return to basic? hopefully :)
	ret

	include "../lib/video_screen.asm"
	include "../lib/video_sprite_2x2.asm"

; random_speed return random speed to A
random_speed:
	ld hl,rnd_seed
	inc (hl)
	ld a,(max_speed)
	ld c,a
	ld hl,(rnd_seed)
	ld a,(hl)
	ld b,a
	ld a,r
	adc a,b
rs_loop:
	cp c
	jp c,rs_end
	jp z,rs_end
	sub c
	jp rs_loop
rs_end:
	ret

;--------------------------------------------------------------------------------
; variables
;--------------------------------------------------------------------------------
spider_count equ 12
max_bullets  equ 8

rnd_seed:	db 0
tmp:		db 0
max_speed:      db 2
spider_index:	db 0
spiders_pos:	ds spider_count,0
bullets:	ds max_bullets*3,0

;--------------------------------------------------------------------------------
; graphics
;--------------------------------------------------------------------------------

spider1:
	db %00000001,%10000000
	db %00010011,%11001000
	db %00100111,%11100100
	db %01000111,%11100010
	db %01001111,%11110010
	db %00101111,%11110100
	db %10011111,%11111001
	db %01000111,%11100010
	db %00110011,%11001100
	db %10001111,%11110001
	db %10000011,%11000001
	db %01100111,%11100110
	db %00011011,%11011000
	db %00000011,%11000000
	db %00000010,%01000000
	db %00000000,%00000000

spider2:
	db %00000001,%10000000
	db %00000011,%11000000
	db %00010111,%11101000
	db %00100111,%11100100
	db %01001111,%11110010
	db %01001111,%11110010
	db %00111111,%11111100
	db %10000111,%11100001
	db %01000011,%11000010
	db %00111111,%11111100
	db %10000011,%11000001
	db %10000111,%11100001
	db %01001011,%11010010
	db %00110011,%11001100
	db %00000001,%10000000
	db %00000000,%00000000

       	end $8000
;eof
