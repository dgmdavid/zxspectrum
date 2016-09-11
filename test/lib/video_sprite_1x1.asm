;
; 1x1 (8x8 pixels) sprite routines
;
; 11/09/2016
; by DGM
;

; Draw1x1Sprite - directly to screen memory (I'm betting it's very slow) :)
; DE - sprite address
; BC - x,y (32x24)
Draw1x1Sprite:
	; is X greater than 31?
	ld a,b
	cp 32
	jr NC,Draw1x1Sprite_end
	; is Y greater than 23?
	ld a,c
	cp 24
	jp NC,Draw1x1Sprite_end
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
	ld a,(de)	;1
	ld (hl),a
	inc h
	inc de
	ld a,(de)	;2
	ld (hl),a
	inc h
	inc de
	ld a,(de)	;3
	ld (hl),a
	inc h
	inc de
	ld a,(de)	;4
	ld (hl),a
	inc h
	inc de
	ld a,(de)	;5
	ld (hl),a
	inc h
	inc de
	ld a,(de)	;6
	ld (hl),a
	inc h
	inc de
	ld a,(de)	;7
	ld (hl),a
	inc h
	inc de
	ld a,(de)	;8
	ld (hl),a
Draw1x1Sprite_end:
	ret

;eof