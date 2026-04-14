
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
    global  CONTADOR,VAR1, VAR2, VAR3
CONTADOR: DS 1
VAR1: DS 1
VAR2: DS 1
VAR3: DS 1


;declaraçã de variáveis globais na região shared
    psect globalData1,global,class=COMMON,space=1,delta=1,noexec
    global W_TEMP, STATUS_TEMP
W_TEMP: DS 1
STATUS_TEMP: DS 1
;declaração da seção de código resetVector
    psect resetVector,global,class=CODE,delta=2 ; PIC10/12/16
resetVector:
    nop
    goto mainFunc
;declaração da seção de código interruptVector
    psect interruptVector,global,class=CODE,delta=2
interruptVector:
;inserir código aqui
    
    MOVWF W_TEMP ;Copy W to TEMP register
    SWAPF STATUS,W ;Swap status to be saved into W

;Swaps are used because they do not affect the status bits

    MOVWF STATUS_TEMP ;Save status to bank zero STATUS_TEMP register
    BCF INTCON, INTCON_INTF_POSITION
    INCF CONTADOR, F
    
    
    
    SWAPF STATUS_TEMP,W ;Swap STATUS_TEMP register into W
;(sets bank to original state)
    MOVWF STATUS ;Move W into STATUS register
    SWAPF W_TEMP,F ;Swap W_TEMP
    SWAPF W_TEMP,W ;Swap W_TEMP into W
    retfie
;declaração da seção de código mainFunc
    psect mainFunc,global,class=CODE,delta=2
mainFunc:
setup:
    BSF STATUS, STATUS_RP0_POSITION
    BCF STATUS, STATUS_RP1_POSITION
    
    BSF TRISB, TRISB_TRISB0_POSITION; RB0 ENTRA
    
    BCF TRISB, TRISB_TRISB1_POSITION; RB1 saida
    
    CLRF TRISD
    
    BSF OPTION_REG, OPTION_REG_INTEDG_POSITION
    BSF STATUS, STATUS_RP0_POSITION
    BSF STATUS, STATUS_RP1_POSITION
    BCF ANSELH, ANSELH_ANS12_POSITION
    BCF ANSELH, ANSELH_ANS10_POSITION
    BCF STATUS, STATUS_RP0_POSITION
    BCF STATUS, STATUS_RP1_POSITION
    CLRF PORTD
    CLRF CONTADOR
    
    BCF INTCON, INTCON_INTF_POSITION
    BSF INTCON, INTCON_INTE_POSITION
    
    BSF INTCON, INTCON_GIE_POSITION

loop:
    MOVLW 00000010B
    XORWF PORTB,F
    MOVF CONTADOR, W
    MOVWF PORTD 
    
    CALL Delay_500ms
;inserir código aqui
    GOTO loop
        
Delay_500ms:
    MOVLW   0x06        ; 
    MOVWF   VAR1
    MOVLW   0x09        ; 
    MOVWF   VAR2
    MOVLW   0x10        ; 
    MOVWF   VAR3
Delay_Loop:
    DECFSZ  VAR3, f       ; Inner loop (3 cycles * count)
    GOTO    Delay_Loop
    DECFSZ  VAR2, f       ; Middle loop
    GOTO    Delay_Loop
    DECFSZ  VAR1, f       ; Outer loop
    GOTO    Delay_Loop
    NOP  
    RETURN
;inserir código aqui
END