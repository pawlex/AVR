#define     F_CPU       12000000UL

#include <avr/cpufunc.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <util/delay.h>
#include <stdio.h>

/*****************************************************************************/

#define     __IOR(x)    (*(volatile uint8_t  *)(0x20+(x)))
#define     __IOW(x)    (*(volatile uint16_t *)(0x20+(x)))

/*****************************************************************************/


#define     IO_BASE_UART0       0x00
#define     IO_BASE_PORTOUT0    0x04
#define     IO_BASE_TIMER0      0x08

/* uart.h */

#define     UDR0        __IOR(IO_BASE_UART0+0x00)
#define     UCSRA0      __IOR(IO_BASE_UART0+0x01)
#define     UCSRB0      __IOR(IO_BASE_UART0+0x02)
#define     UBRR0       __IOR(IO_BASE_UART0+0x03)

/* UCSRA */
#define     RXB8    0
#define     PE      2
#define     DOR     3
#define     FE      4
#define     UDRE    5
#define     TXC     6
#define     RXC     7

/* UCSRB */
#define     TXB8        0
#define     UCSZ        1
#define     UPM0        2
#define     UPM1        3
#define     USBS        4
#define     UDRIE       5
#define     TXCIE       6
#define     RXCIE       7   

/* timer.h */

#define     TCNT0       __IOW(IO_BASE_TIMER0+0x00)
#define     TCR0        __IOR(IO_BASE_TIMER0+0x02)
#define     TSR0        __IOR(IO_BASE_TIMER0+0x03)

#define     TOF         7   /* timer overflow */
#define     TOFIE       7   /* timer overflow interrupt enable */
#define     TPRESC0     0   /* timer prescaler bit 0 */
#define     TPRESC1     1   /* timer prescaler bit 1 */

/* port.h */

#define     PORTOUT0    __IOR(IO_BASE_PORTOUT0+0x00)

/*****************************************************************************/

static int uart_putchar(char c, FILE *stream);

static inline void usleep(uint16_t usec);
static inline void msleep(uint16_t msec);

/* END */
