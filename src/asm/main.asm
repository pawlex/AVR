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
    ; LDI only with R16+
LDI_TEST:
    LDI R16, 0x00AA
    LDI R17, 0x00AA
    LDI R18, 0x00AA
    LDI R19, 0x00AA
    LDI R20, 0x00AA
    LDI R21, 0x00AA
    LDI R22, 0x00AA
    LDI R23, 0x00AA
    LDI R24, 0x00AA
    LDI R25, 0x00AA
    LDI R26, 0x00AA
    LDI R27, 0x00AA
    LDI R28, 0x00AA
    LDI R29, 0x00AA
    LDI R30, 0x00AA
    LDI R31, 0x00AA
MOV_TEST:
    MOV R0, R16
    MOV R1, R16
    MOV R2, R16
    MOV R3, R16
    MOV R4, R16
    MOV R5, R16
    MOV R6, R16
    MOV R7, R16
    MOV R8, R16
    MOV R9, R16
    MOV R10, R16
    MOV R11, R16
    MOV R12, R16
    MOV R13, R16
    MOV R14, R16
    MOV R15, R16
MOVW_TEST:
    ; change pattern
    LDI R16, 0x55
    LDI R17, 0x55
    LDI R18, 0x55
    LDI R19, 0x55
    LDI R20, 0x55
    LDI R21, 0x55
    LDI R22, 0x55
    LDI R23, 0x55
    LDI R24, 0x55
    LDI R25, 0x55
    LDI R26, 0x55
    LDI R27, 0x55
    LDI R28, 0x55
    LDI R29, 0x55
    LDI R30, 0x55
    LDI R31, 0x55
;MOVW
    ;MOVW R1:R0,   R17:R16
    ;MOVW R3:R2,   R19:R18
    ;MOVW R5:R4,   R21:R20
    ;MOVW R7:R6,   R23:R22
    ;MOVW R9:R8,   R25:R24
    ;MOVW R11:R10, R27,R26  
    ;MOVW R13:R12, R29,R28
    ;MOVW R15:R14, R31,R30
    ;
    MOVW R1:R0,   r17:R16
    MOVW R3:R2,   R19:R18
    MOVW R5:R4,   R21:R20
    MOVW R7:R6,   R23:R22
    MOVW R9:R8,   R25:R24
    MOVW R10:R10, R27:R26  
    MOVW R13:R12, R29:R28
    MOVW R15:R14, R31:R30
MEMTEST:
    LDI R17, 0xFF
    LDI XH, HIGH(SRAM_START)
    LDI XL,  LOW(SRAM_START)
    L1:
    ST X+, R16
    ;BRNE MAIN_DONE
    EOR R16, R17 ; ROTATE THE PATTERN
    RJMP L1

MAIN_DONE:
    RJMP MAIN_DONE

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
