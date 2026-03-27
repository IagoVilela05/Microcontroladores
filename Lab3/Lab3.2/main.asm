#include <xc.inc>

; --- VARIÁVEIS (Banco 0) ---
psect globalData,global,class=BANK0,space=1,delta=1,noexec
global VAR1, VAR2, VAR3
VAR1: DS 1
VAR2: DS 1
VAR3: DS 1

; --- VETOR DE RESET ---
psect resetVector,global,class=CODE,delta=2
resetVector:
    nop
    goto mainFunc

; --- FUNÇÃO PRINCIPAL ---
psect mainFunc,global,class=CODE,delta=2
mainFunc:
    ; 1. Configuração de Portas Digitais (Banco 3)
    BSF STATUS, STATUS_RP1_POSITION
    BSF STATUS, STATUS_RP0_POSITION
    CLRF ANSEL          ; Define pinos como digitais [cite: 9, 24]
    CLRF ANSELH         ; Define pinos como digitais [cite: 9, 24]

    ; 2. Configuração de Direção (Banco 1)
    BCF STATUS, STATUS_RP1_POSITION
    BSF STATUS, STATUS_RP0_POSITION
    BSF TRISA, 0        ; Configura RA0 (S2) como entrada [cite: 7, 25]
    BCF TRISB, 0        ; Configura RB0 (LED) como saída [cite: 7, 25]

    ; 3. Inicialização (Banco 0)
    BCF STATUS, STATUS_RP1_POSITION
    BCF STATUS, STATUS_RP0_POSITION
    BCF PORTB, 0        ; Começa com LED apagado [cite: 8, 30]

loop_aguarda_pressionar:
    BTFSC PORTA, 0      ; S2 foi pressionado (0)? [cite: 8]
    GOTO loop_aguarda_pressionar
    
    BSF PORTB, 0        ; Se pressionou, liga o LED [cite: 8, 30]

loop_aguarda_soltar:
    BTFSS PORTA, 0      ; S2 foi solto (transição de 0 para 1)? [cite: 28, 35]
    GOTO loop_aguarda_soltar
    
    ; Transição detectada (Off-Delay de 2s)
    CALL Delay_2s       ; Chama a sub-rotina de tempo [cite: 36]
    BCF PORTB, 0        ; Desliga o LED após os 2s [cite: 30, 33]
    GOTO loop_aguarda_pressionar

; --- SUB-ROTINA DE DELAY (ESTRUTURA FORNECIDA) ---
; Valores ajustados para 4.000.000 de ciclos (2 segundos a 8MHz) 
Delay_2s:
    MOVLW   0x14        ; Valor para Outer loop (VAR1) = 20 em decimal
    MOVWF   VAR1
    MOVLW   0x58        ; Valor para Middle loop (VAR2) = 88 em decimal
    MOVWF   VAR2
    MOVLW   0x55        ; Valor para Inner loop (VAR3) = 85 em decimal
    MOVWF   VAR3
Delay_Loop:
    DECFSZ  VAR3, f     ; Inner loop (3 ciclos * contagem)
    GOTO    Delay_Loop
    DECFSZ  VAR2, f     ; Middle loop
    GOTO    Delay_Loop
    DECFSZ  VAR1, f     ; Outer loop
    GOTO    Delay_Loop
    NOP  
    RETURN

END