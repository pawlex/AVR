#include "main.h"
#include <avr/cpufunc.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <util/delay.h>
#include <stdio.h>
#include "constants.h"

/**/
static FILE mystdout = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
/**/
static int uart_putchar(char c, FILE *stream)
{
    loop_until_bit_is_set(UCSRA0, UDRE);
    UDR0 = c;
    return(0);
}
static inline void usleep(uint16_t usec)
{
    while ( usec )
    { _delay_loop_2((uint32_t)F_CPU/4000000UL);
        usec--;
    }
}
static inline void msleep(uint16_t msec)
{
    while ( msec )
    {
        _delay_loop_2((uint32_t)F_CPU/4000UL);
        msec--;
    }
}

static void print_banner()
{
    printf("%s\n", BANNER0);        
    printf("%s\n", BANNER1);        
    printf("%s\n", BANNER2);        
    printf("%s\n", BANNER1);        
    printf("%s\n", BANNER0);        
}

int main(void)
{
    #define PRESCALE 1
    UBRR0 = PRESCALE-1; // +1 to match TB uart.
    stdout=&mystdout;
    print_banner();
    UCSRB0 |= (1<<RXCIE);
    sei();
    char c;
    while(1)
    {
        __asm("nop\n\t"::);
    }
}

ISR(_VECTOR(3))
{
    char c;
    c=UDR0;
    UDR0=c;
    //if(c > 0x19 && c < 0x7f)
    //{
    //    printf("%s", c);
    //}
}
//EOF
