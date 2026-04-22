# Microcontroladores: Atividades de Laboratório (PIC16F887)

Este repositório contém o código-fonte, esquemáticos e materiais teóricos das atividades práticas realizadas com o microcontrolador **PIC16F887** utilizando a placa de desenvolvimento **EasyPIC6**. Aqui você encontrará a progressão dos estudos, desde a manipulação básica de I/O até sistemas complexos de interrupção.

---

## 🛠️ Especificações de Hardware

* **MCU:** Microchip PIC16F887 (Arquitetura Mid-Range de 8 bits).
* **Clock:** Oscilador de Cristal de Alta Velocidade (HS).
* **Placa de Desenvolvimento:** EasyPIC6.
* **Gravador:** Conexão via ICD ou USB integrado na própria placa.

---

## 📂 Estrutura do Repositório

O repositório está organizado para facilitar a navegação entre a teoria e a prática:

* **`Pratica/`**: Contém os códigos assembly (.s) organizados por aulas e laboratórios.
* **`Teoria/`**: Documentação sobre o sistema de interrupções, ementas da disciplina e slides de aula.
* **`Datasheets e Application Notes/`**: Manuais do PIC16F887, manuais do compilador XC8 e o guia da placa EasyPIC6.
* **`Softwares/`**: Links para download do ambiente de desenvolvimento MPLAB X e dos compiladores necessários.

---

## 🚀 Resumo dos Laboratórios

### Lab 2: Entrada e Saída Digital (I/O)
Implementação de lógica básica para leitura de botão e acionamento de LED.
* **Conceitos:** Gerenciamento de bancos de memória e configuração de pinos analógicos para digitais via registradores `ANSEL` e `ANSELH`.
* **Hardware:** Entrada no pino `RA0` e saída no pino `RB0`.

### Lab 4: Contador Binário com Detecção de Borda
Criação de um contador que incrementa (e decrementa) o valor exibido em um barramento de LEDs ao detectar o pressionamento de botões.
* **Lógica de Borda:** Uso da variável `LAST_STATE` para detectar a borda de subida (*Rising Edge*), garantindo que o contador só mude uma vez por clique.
* **Instruções:** Utilização de `INCF` e `DECF` para manipular o valor no `PORTD`.
* **Hardware:** Entradas em `RA0` e `RA1`, com saída binária de 8 bits no `PORTD`.

### Lab 5: Sistema de Interrupções
Transição da técnica de *polling* (varredura constante) para a técnica de interrupções por hardware, tornando o processamento mais eficiente.
* **Vetor de Interrupção:** Configuração do endereço `0x04` para tratamento de eventos externos.
* **Pino Crítico:** Uso do pino `RB0/INT` como gatilho para a interrupção externa.

---

## 🧠 Conceitos Chave de Programação

### Gerenciamento de Bancos (Architecture Mid-Range)
Como as instruções do PIC reservam apenas 7 bits para o endereço do registrador, a memória é dividida em 4 bancos de 128 bytes.
* **Acesso Manual:** Manipulação dos bits `RP0` e `RP1` no registrador `STATUS`.
* **Acesso Otimizado:** Uso da diretiva `BANKSEL` para que o montador gere automaticamente as trocas de banco necessárias.

### Tabela de Registradores Comuns
| Registrador | Banco | Função Principal |
| :--- | :--- | :--- |
| **PORTX** | 0 | Leitura e Escrita física nos pinos (Nível Lógico). |
| **TRISX** | 1 | Configuração de Direção (0 = Saída, 1 = Entrada). |
| **ANSELX** | 3 | Seleção de modo Analógico ou Digital para os pinos. |

---

> **⚠️ Nota de Hardware:** Ao testar na **EasyPIC6**, certifique-se de que as chaves DIP (SW9 para LEDs) estejam ligadas e que os jumpers de *pull-up/pull-down* dos botões estejam configurados conforme o manual `easypic6_manual_v100.pdf`.
