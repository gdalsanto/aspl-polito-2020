% Assignment 4 - Simulation of analog signals

close all
clear all
clc

addpath ./functions

f0=8;                   % central frequencies in Hz
f1=10;
fc=32;                  % sampling frequency
tc=1/fc;                
N=128;                  % initial number of samples
T0=N*tc;                % observation period 
Deltaf=1/T0             % frequency resolution

%-----------------------FFT

t=[0:tc:T0-tc];                         % time vector     
f=[-N/2:(N/2-1)]*fc/N;                  % frequency vector
x=2*cos(2*pi*f0*t)+cos(2*pi*f1*t);      % signal vector 
X=fftshift(fft(x));                     % FFT

%-----------------------CTFT

x_c=T0*sinc(T0*f);
f0_c=sym(8);
f1_c=sym(10);
y_c=(kroneckerDelta(f,-f0_c)+kroneckerDelta(f,f0_c))+(kroneckerDelta(f,-f1_c)+kroneckerDelta(f,f1_c))/2;
X_c=conv(double(x_c),double(y_c))/tc;

stem(f,abs(X)); hold on; plot(f,abs(X_c(65:192)));
xlabel('f/Hz'); ylabel('amplitude'); legend('|X(k)|','|X(f)|');
title('X(f)=F\{\Pi_{T_0}(t)(2cos(2\pi f_0T_ct)+cos(2\pi f_1T_ct))\}');

%-----------------------zero-padding

M=128;                 % additional samples  
N1=M+N;
T01=N1*tc;
Deltaf1=fc/N1;
x=[x zeros(1,M)];
X=fftshift(fft(x));
f=[-N1/2:(N1/2-1)]*fc/N1;

figure 
stem(f,abs(X));
xlabel('f/Hz'); ylabel('amplitude'); title('|X(k)| with N=256');

%-----------------------spectral-leakage

N2=117;             % new number of samples
T02=N2*tc;    
Deltaf2=1/T02
t=[0:tc:T02-tc];
f=[-N2/2:(N2/2-1)]*fc/N2;

x=2*cos(2*pi*f0*t)+cos(2*pi*f1*t);
X=fftshift(fft(x));

figure
stem(f,abs(X));
xlabel('f/Hz'); ylabel('amplitude'); title('|X(k)| with N=117');
