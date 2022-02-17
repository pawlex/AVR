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

#define UART_RX_BUF_SZ 32
volatile char UART_RX_BUF[UART_RX_BUF_SZ];
volatile uint8_t UART_RX_PTR = 0;

ISR(_VECTOR(0))
{
}
ISR(_VECTOR(1)) // TCR0 INTERRUPT
{
}
ISR(_VECTOR(2))
{
}
ISR(_VECTOR(3)) // UART RX INTERRUPT
{
    char c = UDR0;
    if(UART_RX_PTR < UART_RX_BUF_SZ)
    {
        switch(c)
        {
            // Line Terminator
            case 0x0 : //NULL
            case 0xA : //LF
            case 0xD : //CR
                UART_RX_BUF[UART_RX_PTR] = 0x00; // Terminate the string so it can be printed.
                UART_RX_PTR = 0;
                uart_putchar(0xA, &mystdout);
                print_uart_rx_buffer();
                break;
            // Else add the byte to the array.
            default : 
                UART_RX_BUF[UART_RX_PTR] = c;
                UART_RX_PTR++;
                uart_putchar(c, &mystdout);
                break;
        }
    // Catch the overflow condition.
    } else {
        UART_RX_BUF[0] = 0x00;
        UART_RX_PTR = 0;
    }
}

static inline void print_uart_rx_buffer(void)
{
    printf("%s\n", UART_RX_BUF);
}


static int uart_putchar(char c, FILE *stream)
{
    loop_until_bit_is_set(UCSRA0, UDRE);
    UDR0 = c;
    return(0);
}
static inline void usleep(uint16_t usec)
{
    while ( usec )
    {
        _delay_loop_2((uint32_t)F_CPU/4000000UL);
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

static inline void print_banner(void)
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
    UCSRB0 |= (1<<RXCIE);   // Enabled the UART RX Interrupt
    sei();                  // Enable global interrupts.
    // ENDLESS LOOP
    while(1)
    {
        __asm("nop\n\t"::);
    }
}

