
	org $8000
	
	ld hl,$F000
	ld (hl),0
	ld hl,$F001
	ld (hl),0
loop:
	;halt
	;halt
	ld hl,$F001
	ld a,(hl)
	inc a
	jp nz,skip
	ld (hl),a
	ld hl,$F000
	ld a,(hl)
	inc a
	ld (hl),a
	jp skip2
skip:
	ld (hl),a
skip2:
	ld b,0
	ld hl,$F001
	ld c,(hl)
	call 6683
	ld a,32
	rst 16
	ld b,0
	ld hl,$F000
	ld c,(hl)
	call 6683
	ld a,13
	rst 16
	jp loop

	end $8000