; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = HS             ; Oscillator Selection bits (HS oscillator: High-speed crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = ON            ; Brown Out Reset Selection bits (BOR enabled)
  CONFIG  IESO = ON             ; Internal External Switchover bit (Internal/External Switchover mode is enabled)
  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>

;declaração de variáveis globais no banco 0
psect globalData,global,class=BANK0,space=1,delta=1,noexec
global VAR1, VAR2, LAST_STATE
VAR1: DS 1
VAR2: DS 1
LAST_STATE: DS 1
;declaraçã de variáveis globais na região shared
psect globalData1,global,class=COMMON,space=1,delta=1,noexec
global VAR3, VAR4
VAR3: DS 1
VAR4: DS 1
;declaração da seção de código resetVector
psect resetVector,global,class=CODE,delta=2 ; PIC10/12/16
resetVector:
nop
goto mainFunc
;declaração da seção de código interruptVector
psect interruptVector,global,class=CODE,delta=2
interruptVector:
;inserir código aqui
retfie
;declaração da seção de código mainFunc
psect mainFunc,global,class=CODE,delta=2
mainFunc:
    BCF STATUS, STATUS_RP0_POSITION
    BCF STATUS, STATUS_RP1_POSITION ; bank 0
    ;BCF PORTA, PORTA_RA2_POSITION
    CLRF PORTD

    BSF STATUS, STATUS_RP0_POSITION
    BSF STATUS, STATUS_RP1_POSITION ; bank 3
    MOVLW 00000000B
    MOVWF ANSEL

    BSF STATUS, STATUS_RP0_POSITION
    BCF STATUS, STATUS_RP1_POSITION ; bank 1
    BSF TRISA, TRISA_TRISA0_POSITION
    CLRF TRISD

    BCF STATUS, STATUS_RP0_POSITION
    BCF STATUS, STATUS_RP1_POSITION ; bank 0

loop:
;DET_LOW:
;    BTFSC PORTA, RA0
;    GOTO DET_LOW

;DET_HIGH:
;    BTFSS PORTA, RA0s
;    GOTO DET_HIGH
;    CALL EDGE_DETECTED

EDGE_DET:
    BTFSS PORTA, PORTA_RA0_POSITION
    GOTO ACTUAL_LOW
    BTFSS LAST_STATE, 0
    CALL RISING_EDGE_DETECTED
    BSF LAST_STATE, 0
    GOTO EDGE_DET_EXIT

ACTUAL_LOW:
    BCF LAST_STATE, 0

EDGE_DET_EXIT:
    GOTO loop

RISING_EDGE_DETECTED:
    INCF PORTD, 1
    RETURN

END