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
	; copy 16 lines
	ld b,16
Draw2x2Sprite_loop:
	ld a,(de)
	ld (hl),a
	inc l
	inc de
	ld a,(de)
	ld (hl),a
	dec l
	inc h
	inc de
	djnz Draw2x2Sprite_loop
Draw2x2Sprite_end:
	ret

;eof