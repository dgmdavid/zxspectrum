;
; Screen related routines
;

; SetTempColour - set the temporary colour for the next drawing (via ROM)
MACRO SetTempColour, COLOUR
	ld a,COLOUR
	ld (TEMP_COLOUR_ADDR),a
ENDM

; PrintChar - use ROM to print a character on screen
MACRO PrintChar, CHAR
	ld a,CHAR
	rst 16
ENDM

; PrintString - print a string using the ROM
MACRO PrintString, STRING_PTR,STRING_SIZE
	ld de,STRING_PTR
	ld bc,STRING_SIZE
	call 8252
ENDM

; PrintStringAt - print a string using the ROM
MACRO PrintStringAt, X,Y,STRING_PTR,STRING_SIZE
	ld a,22
	rst 16
	ld a,Y
	rst 16
	ld a,X
	rst 16
	ld de,STRING_PTR
	ld bc,STRING_SIZE
	call 8252
ENDM

ClearScreen:
	ld (ClearScreen_End+1),SP	; Store the stack (self modding code)
	ld SP,&5800			; Set stack to end of screen
	ld DE,&0000			; We are clearing, so set DE to 0
	ld B,0				; We loop 256 times - 12 words * 256 = 6144 bytes
ClearScreen_Loop:
	ds 12,&D5			; &D5 is the code for PUSH DE - this is 12 PUSH DE's
	djnz ClearScreen_Loop
ClearScreen_End:
	ld SP,&0000			; Restore the stack
	ret

; HL - Location of the screen buffer to copy
Copy_Screen:
	ld (Copy_Screen_End+1),SP ; This is some self-modifying code; stores the stack pointer in an LD SP,nn instruction at the end
	exx
	ld HL,16384+16            ; Where the actual screen is, but as we're using the stack it's the right hand side of the buffer
Copy_Screen_Loop:
	exx
	LD SP,HL
	POP AF
	POP BC
	POP DE
	POP IX
	EXX
	EX AF,AF'
	POP AF
	POP BC
	POP DE
	POP IY
	LD SP,HL
	PUSH IY
	PUSH DE
	PUSH BC
	PUSH AF
	EX AF,AF'
	EXX
	PUSH IX
	PUSH DE
	PUSH BC
	PUSH AF
	LD DE,16
	ADD HL,DE
	EXX
	INC H
	LD A,H
	AND &07
	JR NZ,Copy_Screen_Loop
	LD A,H
	SUB 8
	LD H,A
	ld A,L
	ADD A,32
	LD L,A
	JR NC,Copy_Screen_Loop
	LD A,H
	ADD A,8
	LD H,A
	CP &58
	JR NZ,Copy_Screen_Loop
Copy_Screen_End:
	LD SP,0
	EXX
	RET

;eof