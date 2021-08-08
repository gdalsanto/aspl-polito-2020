% Assignment 1 - Stable and unstable filters

close all
clear all
clc

addpath ./function 

%-----------------------IIR-Filters
B1=[1 1.3 0.49 -0.013 -0.029];
A1=[1 -0.4326 -1.6656 0.1253 0.2877];

B2=[0.0725 0.22 0.4085 0.4883 0.4085 0.22 0.0725];
A2=[1 -0.5835 1.7021 -0.8477 0.8401 -0.2823 0.0924];

B3=[1 -1.4 0.24 0.3340 -0.1305];
A3=[1 0.5913 -0.6436 0.3803 -1.0091];

%-----------------------BIBO-stability
abs(roots(A1))
abs(roots(A2))       %<--- stable 
abs(roots(A3))

subplot(1,3,1); zplane(B1,A1); 
title('IIR Filter 1');
axis([-1.5 1.5 -1.5 1.5]);
subplot(1,3,2); zplane(B2,A2); 
title('IIR Filter 2');
axis([-1.5 1.5 -1.5 1.5]);
subplot(1,3,3); zplane(B3,A3); 
title('IIR Filter 3');
axis([-1.5 1.5 -1.5 1.5]);
sgtitle('Pole-zero plots');

N=50;
x=[zeros(1,N) 1 zeros(1,N)];        % Kronecker delta

figure
impz(B2,A2,[-N:N]); hold on; stem([-N:N], filter(B2,A2,x),'--','Color','#77AC30');
xlabel('n/samples'); ylabel('amplitude'); legend('impz','filter')
title('IIR Filter 2 - Stable')

x=[1 zeros(1,N)];                   % Kronecker delta
figure
stem([0:N], filter(B3,A3,x)); hold on ; stem([0:N], filter(B2,A2,x),'--','Color','#77AC30');
xlabel('n/samples'); ylabel('amplitude'); legend('Unstable Filter','Stable Filter')
title('IIR Filters')

