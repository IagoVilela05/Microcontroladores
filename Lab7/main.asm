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
; PIC16F887 Configuration Bit Settings
#include <xc.inc>


; --- Memória de Dados ---
    psect globalData,global,class=BANK0,space=1,delta=1,noexec
    global ESTADO, CONT1, CONT2, CONT3
ESTADO: DS 1   ; Armazena o estado atual da FSM 
CONT1:  DS 1   ; Variáveis para sub-rotina de delay 
CONT2:  DS 1
CONT3:  DS 1

; --- Vetor de Reset ---
    psect resetVector,global,class=CODE,delta=2
resetVector:
    goto setup

; --- Vetor de Interrupção (ADICIONADO PARA CORRIGIR O ERRO 450) ---
    psect interruptVector,global,class=CODE,delta=2
interruptVector:
    ; Como o Lab7 usa Delays por software, apenas retornamos se houver interrupção
    retfie 

; --- Seção Principal ---
    psect mainFunc,global,class=CODE,delta=2
setup:
    ; Banco 3: Configuração Digital 
    BSF STATUS, 5
    BSF STATUS, 6
    CLRF ANSEL    
    CLRF ANSELH  

    ; Banco 1: Configuração de I/O 
    BCF STATUS, 6
    CLRF TRISD      ; Todo PORTD como saída para os 6 LEDs 
    
    BCF STATUS, 5   ; Retorna ao Banco 0
    CLRF PORTD      ; Inicializa em estado seguro 
    CLRF ESTADO     ; Começa no Estado 0 

loop_fsm:
    MOVF   ESTADO, W
    ADDWF  PCL, F
    GOTO   STATE0
    GOTO   STATE1
    GOTO   STATE2
    GOTO   STATE3

STATE0: ; Rua A: Verde (6s) | Rua B: Vermelho
    MOVLW  0x21         ; RD0 (Verde A) e RD5 (Vermelho B) [cite: 144, 189]
    MOVWF  PORTD
    MOVLW  60           ; 60 x 0.1s = 6 segundos [cite: 305]
    CALL   DELAY_VAR
    MOVLW  1
    MOVWF  ESTADO
    GOTO   loop_fsm

STATE1: ; Rua A: Amarelo (3s) | Rua B: Vermelho
    MOVLW  0x22         ; RD1 (Amarelo A) e RD5 (Vermelho B) [cite: 145, 192]
    MOVWF  PORTD
    MOVLW  30           ; 30 x 0.1s = 3 segundos [cite: 305]
    CALL   DELAY_VAR
    MOVLW  2
    MOVWF  ESTADO
    GOTO   loop_fsm

STATE2: ; Rua A: Vermelho | Rua B: Verde (6s)
    MOVLW  0x0C         ; RD2 (Vermelho A) e RD3 (Verde B) [cite: 146, 195]
    MOVWF  PORTD
    MOVLW  60           ; 60 x 0.1s = 6 segundos [cite: 305]
    CALL   DELAY_VAR
    MOVLW  3
    MOVWF  ESTADO
    GOTO   loop_fsm

STATE3: ; Rua A: Vermelho | Rua B: Amarelo (3s)
    MOVLW  0x14         ; RD2 (Vermelho A) e RD4 (Amarelo B) [cite: 147, 198]
    MOVWF  PORTD
    MOVLW  30           ; 30 x 0.1s = 3 segundos [cite: 305]
    CALL   DELAY_VAR
    MOVLW  0            ; Volta para o Estado 0 [cite: 40]
    MOVWF  ESTADO
    GOTO   loop_fsm

; --- Sub-rotinas de Temporização (Software Delay) 
DELAY_VAR:
    MOVWF  CONT3        ; Recebe o multiplicador (30 ou 60)
LOOP_V:
    CALL   DELAY_BASE_01S
    DECFSZ CONT3, F
    GOTO   LOOP_V
    RETURN

DELAY_BASE_01S:         ; O antigo DELAY_CURTO, agora com 0.1s @ 8MHz
    MOVLW  255
    MOVWF  CONT1
L1:
    MOVLW  255
    MOVWF  CONT2
L2:
    DECFSZ CONT2, F
    GOTO   L2
    DECFSZ CONT1, F
    GOTO   L1
    RETURN

    END