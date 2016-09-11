
	org 08000h

ld a,128
ld hl,16384
ld (hl),a
ld d,a
ei
loop2:
ld hl,23560
ld (hl),0
loop1:
ld a,(hl)
cp 0
jr z,loop1
ld a,d
rr a
ld d,a
ld hl,16384
ld (hl),a
jp loop2

	end 08000h
