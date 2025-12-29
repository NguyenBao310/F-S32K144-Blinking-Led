#include "S32K144.h"

#include <stdio.h>

#define GPIOD_base_address 0x400FF0C0

#define PORTD_base_address 0x4004C000

#define PCC_base_address 0x40065000

// Address: 0h base + 0h offset + (4d × i), where i=0d to 31d
#define PORTD_PCR15 (*(volatile uint32_t*)(PORTD_base_address+(4*15))) // RGB RED LED
#define PORTD_PCR16 (*(volatile uint32_t*)(PORTD_base_address+(4*16))) // RGB GREEN LED
#define PORTD_PCR0 (*(volatile uint32_t*)(PORTD_base_address+(4*0))) // RGB BLUE LED

#define PORTD_PDDR (*(volatile uint32_t*)(GPIOD_base_address+0x14))
#define PORTD_PTOR (*(volatile uint32_t*)(GPIOD_base_address+0xC))
#define PORTD_PDOR (*(volatile uint32_t*)(GPIOD_base_address+0x0))

#define PCC_PORTD (*(volatile uint32_t*)(PCC_base_address+0x130)) // clock port d

void delay_ms(uint32_t time)
{
	for(int i=0; i<(time*4800); i++);
}

void delay_s(int time)
{
	for(int i=0; i<(time); i++)
	{
		delay_ms(1000);
	}
}

void setup()
{
	PCC_PORTD |= (1<<30); // enable clock port d

	// clear and set mux GPIO mode
	PORTD_PCR15 &= ~(7<<8);
	PORTD_PCR15 |= (0x001<<8);

	PORTD_PCR16 &= ~(7<<8);
	PORTD_PCR16 |= (0x001<<8);

	PORTD_PCR0 &= ~(7<<8);
	PORTD_PCR0 |= (0x001<<8);

	// set input/output mode
	PORTD_PDDR |= (1<<0)|(1<<15)|(1<<16); // rgb led
	PORTD_PDOR = (1<<0)|(1<<15)|(1<<16); // reset state of rgb led
}

void BlinkLedC()
{
	PORTD_PTOR |= (1<<0);
	delay_s(1);
	PORTD_PTOR |= (1<<0);
	PORTD_PTOR |= (1<<15);
	delay_s(1);
	PORTD_PTOR |= (1<<15);
	PORTD_PTOR |= (1<<16);
	delay_s(1);
	PORTD_PTOR |= (1<<16);
}

extern void BlinkLedS();

int main(void) {
	// setup();
	// for(;;)
	// {
	//   BlinkLedC();
	// }
	BlinkLedS();


    return 0;
}
