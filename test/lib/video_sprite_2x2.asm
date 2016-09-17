;
; 2x2 (16x16 pixels) sprite routines
;
; 11/09/2016
; by DGM
;

; Draw2x2Sprite - directly to screen memory (I'm betting it's very slow) :)
; DE - sprite address
; BC - x,y (30x22)
Draw2x2Sprite:
	; is X greater than 30?
	ld a,b
	cp 31
	jr NC,Draw2x2Sprite_end
	; is Y greater than 22?
	ld a,c
	cp 23
	jp NC,Draw2x2Sprite_end
	; calculate screen address
	; X
	ld l,b
	ld a,c
	and %00011000
	or %01000000
	; Y
	ld h,a
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
	ld b,8
Draw2x2Sprite_loop1:
	ld a,(de)
	ld (hl),a
	inc l
	inc de
	ld a,(de)
	ld (hl),a
	dec l
	inc h
	inc de
	djnz Draw2x2Sprite_loop1
	; have we gone to the next screen third?
	dec h
	ld a,h
	and %11111000
	ld h,a
	ld a,l
	and %11100000
	cp %11100000
	jp nz,Draw2x2Sprite_skip
	ld a,l
	and %00011111
	ld l,a
	ld a,h
	add a,%00001000
	ld h,a
	jp Draw2x2Sprite_skip2
Draw2x2Sprite_skip:
	ld a,l
	add a,%00100000
	ld l,a
Draw2x2Sprite_skip2:
	; copy the next 8 lines
	ld b,8
Draw2x2Sprite_loop2:
	ld a,(de)
	ld (hl),a
	inc l
	inc de
	ld a,(de)
	ld (hl),a
	dec l
	inc h
	inc de
	djnz Draw2x2Sprite_loop2
Draw2x2Sprite_end:
	ret

;eof