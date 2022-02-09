;   program : main.asm
;   author  : Paul Komurka github.com/pawlex
;   date    : 2022-01-21

.include "m328Pdef.inc"

.SET RAM_START = 0x0060            ;   NON-IMMUTABLE
.EQU RAM_END   = 0x00FF

.EQU NUMERICAL_CONSTANT = 0x0060    ;   IMMUTABLE
.DEF REGISTER_CONSTANT  = R1        ;

.MACRO DELAY4
    NOP
    NOP
    NOP
    NOP
.ENDMACRO

.CSEG
.ORG 0x00                   ; JUMP TABLE
    RJMP    MAIN            ; RESET VECTOR
    RJMP    ISR0            ; ISR 0
    RJMP    ISR1            ; ISR 1

MAIN:
    RJMP    MAIN            ; JMP$

ISR0:
    RJMP    ISR0

ISR1:
    RJMP    ISR1

PORT0:
    RJMP    PORT0
;   LDI R16,(1<<PINB0)      ; load 00000001 into register 16
;   OUT     DDRB,  R16      ; write register 16 to DDRB
;   OUT     PORTB, R16      ; write register 16 to PORTB


.DSEG

.ESEG

; STACK
;   PUSH R1
;   POP  R1
;   RCALL LABEL
;   RET
; SETUP THE STACK
;   LDI R1, HIGH(RAMEND)    ; high byte
;   LDI R2, LOW(RAMEND)     ; low  byte
;   OUT SPH,R1              ; set stack..
;   OUT SPL,R2              ; ..pointers

; DIRECT ADDRESSING
;   STS 0x0000, R1          ; STORE R1 -> 0x0 (RAM)
;   LDS R1, 0x0000          ; LOAD R1  <- 0x0 (RAM)

; INDIRECT ADDRESSING
; X (XH:XL, R27:R26), Y (YH:YL, R29:R28) and Z (ZH:ZL, R31:R30). 
;   LDI XH, HIGH(0x0060)
;   LDI XL,  LOW(0x0060)
;   ; X effective address is 0x0060
;   LD R1, X+   ; load 0x6060 into R1 and inc X (X++)
;   LD R2, X-   ; load 0x6061 into R2 and dec X (X--)
;   LD R3, X    ; load 0x6060 into R3

; INDIRECT ADDRESS + REGISTER MULTIPLICATION
; Can only be done with the Y- and Z-register-pair, not with the X-pointer!
;   LDI YH, HIGH(0x0060)
;   LDI YL,  LOW(0x0060)
;   STD Y+2, R1             ; STORE R1 -> 0x0062
;   LDD R2, Y+2             ; LOAD R2 with contents of 0x0062

; Branch instructions zero-flag is set on last inc/dec of any register
;   BRCC/BRCS ; Carry-flag 0 oder 1
;   BRSH ; Equal or greater
;   BRLO ; Smaller
;   BRMI ; Minus
;   BRPL ; Plus
;   BRGE ; Greater or equal (with sign bit)
;   BRLT ; Smaller (with sign bit)
;   BRHC/BRHS ; Half overflow flag 0 or 1
;   BRTC/BRTS ; T-Bit 0 or 1
;   BRVC/BRVS ; Two's complement flag 0 or 1
;   BRIE/BRID ; Interrupt enabled or disabled
