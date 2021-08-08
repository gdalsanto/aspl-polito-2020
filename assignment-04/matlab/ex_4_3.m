% Assigment 3 - The Gibbs phenomenon

close all
clear all
clc

addpath ./functions

B=4;                    % bandwidth of LP filter Hz
T=10;                   % window duration s
fs=20;                  % sampling frequency Hz
ts=1/fs;
t=[-T/2:ts:T/2-ts];
N=length(t);
f=[-(10*N)/2:((10*N)/2-1)]*(fs/(10*N));

%-----------------------Sine-Int-Function

s1=sinint(pi*T.*(f-B/2))/pi;
s2=sinint(pi*T.*(f+B/2))/pi;
Xt=s2-s1;

figure; hold on;
plot(f,-s1); plot(f,s2); plot(f,Xt);
legend('$-Si(\pi T(f-B/2))/\pi$','$Si(\pi T(f+B/2))/\pi$','$[Si(\pi T(f+B/2))/\pi-Si(\pi T(f-B/2))/\pi]/\pi$','interpreter','latex','FontSize',12);
xlabel('f/Hz','interpreter','latex','FontSize',18); ylabel('amplitude','interpreter','latex','FontSize',18)
title('Sine Integral function','interpreter','latex','FontSize',18)

%-----------------------Sinc-Function

xt=B*sinc(B*t);
figure; plot(t,xt);
title('$x_T(t)=BSinc(Bt)\cdot rect_T(t)$','interpreter','latex','FontSize',18);
xlabel('t/s','interpreter','latex','FontSize',18); ylabel('amplitude','interpreter','latex','FontSize',18)

%-----------------------Gibbs-phenomenon

xt=[zeros(1,4*N+N/2) xt zeros(1,4*N+N/2)];        % zero-pad
X=fftshift(fft(xt))*ts;

figure; hold on
plot(f,abs(X)); plot(f,abs(Xt),'--');
xlabel('f/Hz','interpreter','latex','FontSize',18); ylabel('amplitude','interpreter','latex','FontSize',18)
title('Gibbs phenomenon, $B=4Hz$, $T=10s$','interpreter','latex','FontSize',18);
legend('$|X(k)|$','$|X_T(f)|$','interpreter','latex','FontSize',18);
