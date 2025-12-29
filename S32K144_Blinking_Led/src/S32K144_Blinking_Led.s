.section .text
.align 4
.global BlinkLedS

.equ GPIOD_base_address, 0x400FF0C0
.equ PORTD_base_address, 0x4004C000
.equ PCC_base_address, 0x40065000

.equ PORTD_PCR15, (PORTD_base_address+(4*15)) // RGB RED LED
.equ PORTD_PCR16, (PORTD_base_address+(4*16)) // RGB GREEN LED
.equ PORTD_PCR0, (PORTD_base_address+(4*0)) // RGB BLUE LED

.equ PORTD_PDDR, (GPIOD_base_address+0x14)
.equ PORTD_PTOR, (GPIOD_base_address+0xC)
.equ PORTD_PDOR, (GPIOD_base_address+0x0)

.equ PCC_PORTD, (PCC_base_address+0x130) // clock port d

BlinkLedS:
	/* enable clock port d */
	LDR R1, =PCC_PORTD
	LDR R2, [R1]
	LDR R3, =(1<<30)
	ORR R2, R2, R3
	STR R2, [R1]

	// clear and set mux GPIO mode
	LDR R1, =PORTD_PCR15
	LDR R2, [R1]
	LDR R3, =(000<<8)
	LDR R4, =(001<<8)
	AND R2, R2, R3
	ORR R2, R2, R4
	STR R2, [R1]

	LDR R1, =PORTD_PCR16
	LDR R2, [R1]
	LDR R3, =(000<<8)
	LDR R4, =(001<<8)
	AND R2, R2, R3
	ORR R2, R2, R4
	STR R2, [R1]

	LDR R1, =PORTD_PCR0
	LDR R2, [R1]
	LDR R3, =(000<<8)
	LDR R4, =(001<<8)
	AND R2, R2, R3
	ORR R2, R2, R4
	STR R2, [R1]

	// set input/output mode
	LDR R1, =PORTD_PDDR
	LDR R2, [R1]
	LDR R3, =((1<<0)|(1<<15)|(1<<16))
	ORR R2, R2, R3
	STR R2, [R1]

	LDR R1, =PORTD_PDOR
	LDR R2, =((1<<0)|(1<<15)|(1<<16))
	STR R2, [R1]

LOOP:
	// blink led function
	// PORTD_PTOR |= (1<<0);
	LDR R1, =PORTD_PTOR
	LDR R2, =(1<<0)
	STR R2, [R1]
	BL delay1s
	STR R2, [R1]

	LDR R2, =(1<<15)
	STR R2, [R1]
	BL delay1s
	STR R2, [R1]

	LDR R2, =(1<<16)
	STR R2, [R1]
	BL delay1s
	STR R2, [R1]

	B LOOP

delay1s:
	LDR R5, =16000000
delayloop:
	SUB R5, R5, #1
	BNE delayloop
	BX LR
