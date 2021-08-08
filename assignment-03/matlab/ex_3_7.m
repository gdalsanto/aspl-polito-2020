% Assignment 7 - Bartlett periodogram custom function
close all
clear all
clc

addpath ./functions 

N=2e4;                  % length o the sequence
var=25;                 % variance of WGN W

W=sqrt(var).*randn(1,N);    % zero mean, normal dist

%-----------------------LP-Filter
n=-200:200;
h=.5*sinc(n./2);
y=filter(h,1,W);

%-----------------------Bartlett
M=25;                   % number of segments 
D=N/M;                  % D - samples in  a segment
[Sx0,f0]=pwelch(y, rectwin(D), 0, D, 1, 'centered');

%-----------------------My-Bartlett-Function
[Sx1,f1]=my_Bartlett(y,length(y),M);

figure; hold on
plot(f0,10*log10(Sx0)); plot(f1,10*log10(Sx1),'--');
xlabel('f/Hz'); ylabel('E\{PSD\}/dB');
title('Bartlett periodogram'); 
legend('pwelch','my\_Bartlett');








