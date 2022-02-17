
.NOLIST
/* .include "m1280def.inc" */
.LIST

/*
    Macro to set the Stack Pointer to end of ram
    Input Parameters: none
.macro SET_STACK
    ldi    r16, LOW(RAMEND)
    out    spl, r16
    ldi    r16, HIGH(RAMEND)
    out    sph, r16
.endmacro

*/

/*
    Data segment
    All we can do here is reserve a    portion of the data 
    segment for our target string.  We cannot initialize
    data in this segment. We are setting aside 32 bytes
    (0x20) for our target string.
*/
.dseg
msgd:
    .byte    0x20

/*
    Code Segment
    Use .org to set the base address in code segment where
    we want the code to begin, in this case 0 or beginning
    of the segment.  The first part of the code segment is
    reserved for the interrupt/jump table and the first 
    item in the table is the reset vector which we put a 
    jump instruction to the first line of our code..  Since
    we are not declaring any other interrupts we can ignore
    the    rest of the table and just add a 2nd .org setting 
    the start label or beginning of the    code at location 
    0x20.
*/
.cseg


.org 0
    rjmp    start

 start:
    nop
    rjmp start

    
