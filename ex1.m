close all
clear
clc

fs = 60; 
t = 0:1/fs:3; % Frequência de amostragem e tempo de 3 segundos
N = length(t); % Tamanho do vetor tempo
f = 5; 
sinal = 2 * sin(2 * pi * f * t); % Gerando o sinal de 5 Hz

% Gráfico no Domínio do Tempo
subplot(2,1,1);
plot(t, sinal);
title('Sinal Senoidal de 5 Hz (Domínio do Tempo)');
xlabel('Tempo (s)');
ylabel('Amplitude (V)');

% Processamento da Frequência
y = fft(sinal); % Calcula a Transformada de Fourier
y = y(1:floor(length(y)/2));

freq = (0:N-1) * fs / N;
freq = freq(1:floor(length(freq)/2));
length(sinal)
%    Gráfico no Domínio da Frequência
subplot(2,1,2);
plot(freq, abs(y));
title('Espectro do sinal (Domínio da Frequência)');
ylabel('|y(f)|');
xlabel('Frequência (Hz)');
