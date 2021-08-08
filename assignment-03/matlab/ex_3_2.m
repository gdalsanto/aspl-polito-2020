% Assignment 2 - DFT custom function

close all
clear all
clc

addpath ./functions 

N=1e2;                      % number of elements
x=randn(1,N);               % input signal vector
f=[-N/2:(N/2-1)]/N;         % frequency vector

tic
X_k=my_DFT(x,N);            % custom DFT
toc

tic
X_k2=fftshift(fft(x));      % FFT
toc

subplot(1,2,1); 
plot(f,abs(X_k));
hold on
plot(f,abs(fftshift(fft(x))),'--r');
xlabel('f/Hz'); ylabel('magnitude');
title('|X(k)|');
legend('my\_DFT','fft');

subplot(1,2,2); 
plot(f,unwrap(atan2(imag(X_k),real(X_k)))*180/pi);
hold on
plot(f,unwrap(atan2(imag(X_k2),real(X_k2)))*180/pi,'--r');
xlabel('f/Hz'); ylabel('phase');
title('\angle X(k)');
legend('my\_DFT','fft');

sgtitle('my\_DFT(x[n]) - FFT(x[n]) comparison');
