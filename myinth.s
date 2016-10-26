; Generated by c86 (BYU-NASM) 5.1 (beta) from myinth.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
L_myinth_1:
	DW	1
L_myinth_2:
	DW	0
L_myinth_3:
	DB	"RESET",0
	ALIGN	2
resetISRC:
	; >>>>> Line:	9
	; >>>>> { 
	jmp	L_myinth_4
L_myinth_5:
	; >>>>> Line:	10
	; >>>>> printString("RESET"); 
	mov	ax, L_myinth_3
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	11
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_myinth_4:
	push	bp
	mov	bp, sp
	jmp	L_myinth_5
L_myinth_8:
	DB	0xA,0
L_myinth_7:
	DB	0xA,"TICK",0
	ALIGN	2
tickISRC:
	; >>>>> Line:	15
	; >>>>> { 
	jmp	L_myinth_9
L_myinth_10:
	; >>>>> Line:	20
	; >>>>> printString("\nTICK"); 
	mov	ax, L_myinth_7
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	21
	; >>>>> printInt(n); 
	push	word [L_myinth_1]
	call	printInt
	add	sp, 2
	; >>>>> Line:	22
	; >>>>> printString("\n"); 
	mov	ax, L_myinth_8
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	24
	; >>>>> n++; 
	inc	word [L_myinth_1]
	mov	sp, bp
	pop	bp
	ret
L_myinth_9:
	push	bp
	mov	bp, sp
	jmp	L_myinth_10
L_myinth_15:
	DB	") IGNORED",0xA,0
L_myinth_14:
	DB	0xA,"KEYPRESS (",0
L_myinth_13:
	DB	0xA,"DELAY COMPLETE",0xA,0
L_myinth_12:
	DB	0xA,"DELAY KEY PRESSED",0xA,0
	ALIGN	2
keyboardISRC:
	; >>>>> Line:	30
	; >>>>> { 
	jmp	L_myinth_16
L_myinth_17:
	; >>>>> Line:	31
	; >>>>> if(KeyBuffer == 'd') 
	cmp	word [KeyBuffer], 100
	jne	L_myinth_18
	; >>>>> Line:	34
	; >>>>> printString("\nDELAY KEY PRESSED\n 
	mov	ax, L_myinth_12
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	35
	; >>>>> for(i = 0; i < 5000; i++) 
	mov	word [L_myinth_2], 0
	jmp	L_myinth_20
L_myinth_19:
L_myinth_22:
	; >>>>> Line:	38
	; >>>>> } 
	inc	word [L_myinth_2]
L_myinth_20:
	cmp	word [L_myinth_2], 5000
	jl	L_myinth_19
L_myinth_21:
	; >>>>> Line:	40
	; >>>>> printString("\nDELAY COMPLETE\n"); 
	mov	ax, L_myinth_13
	push	ax
	call	printString
	add	sp, 2
	jmp	L_myinth_23
L_myinth_18:
	; >>>>> Line:	44
	; >>>>> printString("\nKEYPRESS ("); 
	mov	ax, L_myinth_14
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	45
	; >>>>> printChar((char)KeyBuffer); 
	push	word [KeyBuffer]
	call	printChar
	add	sp, 2
	; >>>>> Line:	46
	; >>>>> printString(") IGNORED\n"); 
	mov	ax, L_myinth_15
	push	ax
	call	printString
	add	sp, 2
L_myinth_23:
	mov	sp, bp
	pop	bp
	ret
L_myinth_16:
	push	bp
	mov	bp, sp
	jmp	L_myinth_17
