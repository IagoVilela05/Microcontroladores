
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
<<<<<<< HEAD
    #include <xc.inc>
;declaração de variáveis globais no banco 0
    psect globalData,global,class=BANK0,space=1,delta=1,noexec
    global VAR1, VAR2
VAR1: DS 1
VAR2: DS 1
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
=======
#include <xc.inc>
;declaração de variáveis globais no banco 0
psect globalData,global,class=BANK0,space=1,delta=1,noexec
global VAR1, VAR2, VAR3
VAR1: DS 1
VAR2: DS 1
VAR3: DS 1
;declaração de variáveis globais na região shared
psect globalData1,global,class=COMMON,space=1,delta=1,noexec
global VAR4, VAR5
VAR4: DS 1
VAR5: DS 1
;declaração da seção de código resetVector
psect resetVector,global,class=CODE,delta=2 ; PIC10/12/16
resetVector:
nop
goto mainFunc
>>>>>>> 325ffc38f74c3e2a298e8e30411303a8aecee5f5
;declaração da seção de código interruptVector
psect interruptVector,global,class=CODE,delta=2
interruptVector:
;inserir código aqui
<<<<<<< HEAD
    retfie
;declaração da seção de código mainFunc
psect mainFunc,global,class=CODE,delta=2
mainFunc:
    BCF STATUS, STATUS_RP0_POSITION
    BCF STATUS, STATUS_RP1_POSITION;BANK O
    
    BSF STATUS, STATUS_RP0_POSITION 
    BCF STATUS, STATUS_RP1_POSITION;BANK 1
    BSF TRISA, TRISA_TRISA0_POSITION ;BOTAO RA0 /SW2 COMO ENTRADA
    BCF TRISB, TRISB_TRISB0_POSITION ;LED RB0 COMO SAIDA
    
    BSF STATUS, STATUS_RP0_POSITION
    BSF STATUS, STATUS_RP1_POSITION; BANK 3
    CLRF ANSEL
    CLRF ANSELH
    
    BCF STATUS, STATUS_RP0_POSITION
    BCF STATUS, STATUS_RP1_POSITION;BANKO
    
;inserir código aqui

loop_inicial:
    BTFSS PORTA, 0
    GOTO botao_nao_apertado
    GOTO botao_apertado
    
botao_apertado:
    BCF PORTB, 0
    BTFSS PORTA, 0
    GOTO botao_apertado
    GOTO DELAY_2s
    
    
   DELAY_2s:
    movlw   0x03        ; Valor para d3
    movwf   VAR3
    movlw   0x18        ; Valor para d2
    movwf   VAR2
    movlw   0x02        ; Valor para d1
    movwf   VAR1
    Delay_0:
    decfsz  VAR1, f       ; 1 ciclo (2 se pular)
    goto    Delay_0     ; 2 ciclos
    decfsz  VAR2, f       ; 1 ciclo
    goto    Delay_0     ; 2 ciclos
    decfsz  VAR3, f       ; 1 ciclo
    goto    Delay_0     ; 2 ciclos
    GOTO loop_inicial
    
    
botao_nao_apertado:
    BSF PORTB, 0
    GOTO loop_inicial
    

    ;MOVLW 00000100B
    ;XORWF PORTA, F
    ;CALL Delay_500ms
;inserir código aqui
    
;inserir código aqui
    
    
;Delay_500ms:
    ;MOVLW   0x06        ; 
    ;MOVWF   VAR1
    ;MOVLW   0x09        ; 
    ;MOVWF   VAR2
    ;MOVLW   0x10        ; 
    ;MOVWF   VAR3
;Delay_Loop:
    ;DECFSZ  VAR3, f       ; Inner loop (3 cycles * count)
    ;GOTO    Delay_Loop
    ;DECFSZ  VAR2, f       ; Middle loop
    ;GOTO    Delay_Loop
    ;DECFSZ  VAR1, f       ; Outer loop
    ;GOTO    Delay_Loop
    ;NOP  
    ;RETURN
    END ;fim do programa




=======
retfie
;declaração da seção de código mainFunc
psect mainFunc,global,class=CODE,delta=2
mainFunc:
;inserir código aqui
    BSF STATUS, STATUS_RP1_POSITION
    BSF STATUS, STATUS_RP0_POSITION 
    CLRF ANSEL
    CLRF ANSELH
    
    BCF STATUS, STATUS_RP1_POSITION    
    BSF STATUS, STATUS_RP0_POSITION
    BSF TRISA,0
    BCF TRISB,0
    
    BCF STATUS, STATUS_RP1_POSITION    
    BCF STATUS, STATUS_RP0_POSITION
    BSF PORTB, 0 ; NIVEL LOGICO BAIXO

 
loop:   
;inserir código aqui
    BTFSS PORTA ,0 
    GOTO desligaLed
ligaLed:
    BSF PORTB , 0 
    GOTO loop
desligaLed: 
    BCF PORTB, 0 
    GOTO loop

   
;inserir código aqui

END ;fim do programa
>>>>>>> 325ffc38f74c3e2a298e8e30411303a8aecee5f5



