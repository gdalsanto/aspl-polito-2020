% Assignment 1 - Periodic Sinc

close all
clear all
clc

addpath ./functions

N=1e4;                          % number of samples
f=linspace(-1,1,N);             % frequencies
L=3:7;
X=sin(pi*f.*L(:))./sin(pi*f).*exp(-i*pi*f.*(L(:)-1));      % DTFT of the rect pulse

figure
for i=1:length(L)
    subplot(2,3,i); plot(f,abs(X(i,:)));
    xlabel('f/Hz'); ylabel('|X(e^{j2\pi f})|');
    title(['L=', num2str(L(i))]);
end
sgtitle('X(e^{j2\pi f})=sin(\pi fL)/sin(\pi f)e^{-j\pi f(L-1)}');

figure
Z=sin(pi*f.*L(:))./sin(pi*f);                       % periodic sinc function 
for i=1:length(L)
    subplot(2,3,i); plot(f,Z(i,:));                 % priod T=1 for n odd, T=2 or n even
    xlabel('f/Hz'); ylabel('Z(e^{j2\pi f})');
    title(['L=', num2str(L(i))]);
end
sgtitle('Periodic Sinc Function Z(e^{j2\pi f})=sin(\pi fL)/sin(\pi f)') 

%-----------------------L-9
figure
hold on
Z_9=sin(pi*f*9)./sin(pi*f);
plot(f,Z_9); plot(f,9*sinc(f*9));
legend('Z(e^{j2\pi f})','LSinc(fL)');
xlabel('f/Hz'); ylabel('amplitude');
title('L=9');


%-----------------------Energy
df=2/N;
% Main lobe 
fs0_low=4445;           % lower freq index
fs0_hig=5556;           % higher freq index
Ez_s0=sum(abs(Z_9(fs0_low:fs0_hig).^2))*df;
Es_s0=sum(abs(9*sinc(f(fs0_low:fs0_hig)*9)).^2)*df;
% firsts side lobes 
fs1_low=3334;           % lower freq index
fs1_hig=6667;           % higher freq index
Ez_s1=sum(abs(Z_9(fs1_low:fs1_hig).^2))*df;
Es_s1=sum(abs(9*sinc(f(fs1_low:fs1_hig)*9)).^2)*df;
% seconds side lobes
fs2_low=2223;           % lower freq index
fs2_hig=7778;           % higher freq index
Ez_s2=sum(abs(Z_9(fs2_low:fs2_hig).^2))*df;
Es_s2=sum(abs(9*sinc(f(fs2_low:fs2_hig)*9)).^2)*df;

Es_s0/Ez_s0*100;
Es_s1/Ez_s1*100;
Es_s2/Ez_s2*100;