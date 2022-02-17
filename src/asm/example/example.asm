
.NOLIST
/* .include "m1280def.inc" */
.LIST

/*
    Macro to set the Stack Pointer to end of ram
    Input Parameters: none
*/
/*
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

/*
    End of Jump table and start of our code.
*/
.org 0x20
start:
    SET_STACK            ;Invoke our macro to set stack ptr
    /*
        The Z-resister is used to access Program memory.  
        This 16 bit register pair is used as a 16 bit ptr 
        to the Program Memory where the most significant 15 
        bits select the word address and the LSB is the 
        Low/High bit select therefore we must multiply the 
        address by 2 by shifting left one place.  We could 
        have also have just multiplied by 2;
            ldi    ZH,high(msg*2)
            ldi    ZL,low(msg*2)
        either way is acceptible!
    */
     ldi        ZH,high(msg<<1)    ;Set Z pointer to message
    ldi        ZL,low(msg<<1)    
    rcall    get_length        ;call subroutine to get length
    ldi        XH,high(msgd)    ;Set X pointer to destination in
    ldi        XL,low(msgd)    ; data memory.
    add        XL,r17            ;Add count to X pointer,
    /*
        Once we have the length we use it to loop through 
        each item loading it into R24, do a post increment 
        and write the character to the current location 
        pointed to by the X-register pain.  We then 
        decrement the X pointer then the counter and if 
        not zero branch to loop and repeat.
    */
loop:
    lpm        r24,Z+
    st        X,r24
    dec        XL
    dec        r17
    brge    loop
    ret
/*
    Subroutine to count the length of the string that is 
    pointed    to by the Z-register.
        ZH:ZL    Pointer to string
        R17        Calcualted string length
    Upon entry we push the initial value of the Z-register 
    for use later.
    
    We get the length by loading the byte currently pointed 
    to by the Z-register and doing a post increment.  
    We check the byte and if it is not the terminating zero 
    we increment the count and jump to loop to repeat the 
    sequence of instructions.

    Upon exit we restore the intial Z-register values.
*/
get_length:
    push    ZH
    push    ZL
    ldi        r17,0
loop1:
    lpm        r24,Z+
    cpi        r24,0
    breq    exit
    inc        r17
    rjmp        loop1
exit:
    pop        ZL
    pop        ZH
    ret
/*
    Our meesage string..
*/
msg:
    .db        "String to be reversed",0
