#include "main.h"
#include <avr/cpufunc.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <util/delay.h>
#include <stdio.h>

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
static void test_printf(void)
{
    stdout=&mystdout;
    uint16_t i=0;
    //float myfloat = 3.14159F;
    //unsigned long mylong = 4000000;
    printf("char   is %d bytes\n", sizeof(char));
    //printf("int    is %d bytes\n", sizeof(int));
    //printf("long   is %d bytes\n", sizeof(long));
    //printf("double is %d bytes\n", sizeof(double));
    //printf("float  is %d bytes\n", sizeof(float));
    //PORTOUT0 = 0x90;
    //PORTOUT0 ^= 0x03;
    //PORTOUT0 = 0xDE;
    //PORTOUT0 = 0xAD;
    //PORTOUT0 = 0xBE;
    //PORTOUT0 = 0xEF;
    //printf("float me bro %.6f\n", myfloat); // vfprintf supports printing floats on avr-gcc
    //printf("my donger is so long, how long?  %lu\n", mylong/2/2/2);
    while (1)
    {   
        //printf("[x] 0x%04x => %08d\n",i,i*i);
        //printf("[x] 0x%04x => %05.02f\n",i,(float)i);
        //printf("[x] 0x%04x => %08d\n",i,i%11);
        //printf("[x] 0x%04x => 0x%06x\n",i,i^0x5555);
        //msleep(1);
        //usleep(1);
        i++;
    }
}

static void memory_test(void)
{
    printf("STARTING UP\n");
    uint8_t i;
    uint8_t  q0,q1,q2;
    uint8_t c = 0;
    #define BUFFER_SIZE 32
    uint8_t b0[BUFFER_SIZE];
    uint8_t b1[BUFFER_SIZE];
    uint8_t b2[BUFFER_SIZE];
    while(1)
    {
        for(i=0; i<BUFFER_SIZE; i++)
        {
            b0[i] = i;
            b1[i] = i;
            b2[i] = i;
        }
        for(i=0; i<BUFFER_SIZE; i++)
        {
            q0 = b0[i];
            q1 = b1[i];
            q2 = b2[i];
            if(q0 != i || q1 != i || q2 != i)
            {
                printf("[0] address 0x%04x : 0x%02x\n", i, q0);
                printf("[1] address 0x%04x : 0x%02x\n", i, q1);
                printf("[2] address 0x%04x : 0x%02x\n", i, q2);
            } 
        }
        c++;
        printf("0x%02x bytes\n", c);
        //c += BUFFER_SIZE;
        //c += BUFFER_SIZE;
        //c += BUFFER_SIZE;
        //printf("0x%08lx bytes tested\n", c);
    }
}

int main(void)
{
 #define PRESCALE 1
 UBRR0 = PRESCALE-1; // +1 to match TB uart.
 stdout=&mystdout;
 //test_printf();
 memory_test();
 while(1)
 {
     __asm("nop\n\t"::);
 }
 return (0);
}

