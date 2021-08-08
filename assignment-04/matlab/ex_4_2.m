% Assignmet 2 - IIR Fileter Design

clear all 
close all
clc

addpath ./functions

f1=5;               % Hz
f2=50;          
fs=5e2;             % sampling frequency in Hz
T=20;               % observation time in s
t=0:1/fs:T;         % time vector

var=[10 1 0.1];                         % variance
W=sqrt(var(:)).*randn(1,length(t));     % WGN W(t)

x=cos(2*pi*f1*t)+cos(2*pi*f2*t)+W;      % signal X(t)

%-----------------------PSD-Esimation
N=length(t)-1;      % number of intervals 
M=25;               % number of segments
D=N/M;              % samples in each segment 
n_overlap=D/2;      % 50% overlap
[Sx,f]=pwelch(x(1,:),hamming(D),n_overlap,D,fs,'centered');

figure; plot(f,10*log10(Sx));
xlabel('f/Hz'); ylabel('E\{S_X(f)\}/dB');
title('Estimated PSD S_X')

%-----------------------Butterworth-BP-Filter
Wp=[45 55]/(fs/2);  % Pass-band edge freq
Ws=[35 65]/(fs/2);  % Stop-band edge freq
Rp=1;               % Pass-band ripple
Rs=30;              % Stop-band attenuation
[N1,Wn]=buttord(Wp,Ws,Rp,Rs);       
[B1,A1]=butter(N1,Wn);

figure; 
freqz(B1,A1,[5:1:95],fs)
ylim([-60 0])
title('Butterworth BP filter');

%-----------------------Filtering

y1=filter(B1,A1,x(1,:));
[Sy1, f]=pwelch(y1,hamming(D),n_overlap,D,fs,'centered');

figure; hold on;
plot(f,10*log10(Sx)); plot(f,10*log10(Sy1));
xlabel('f/Hz'); ylabel('E\{S(f)\}/dB');
title('Estimated PSD S_X(f) and S_{Y_1}(f) - Butterworth')
legend('S_X(f)','S_{Y_1}(f)')

%-----------------------Elliptic-BP-Filter
[N2,Wn]=ellipord(Wp,Ws,Rp,Rs);       
[B2,A2]=ellip(N2,Rp,Rs,Wp);
figure 
freqz(B2,A2,[5:1:95],fs)
title('Elliptic BP filter');

%-----------------------Filtering
y2=filter(B2,A2,x(1,:));
[Sy2, f]=pwelch(y2,hamming(D),n_overlap,D,fs,'centered');

figure; hold on;
plot(f,10*log10(Sx)); plot(f,10*log10(Sy2));
xlabel('f/Hz'); ylabel('E\{S(f)\}/dB');
title('Estimated PSD S_X(f) and S_{Y_2}(f) - Elliptic Filter')
legend('S_X(f)','S_{Y_2}(f)')

%-----------------------Chebyshev-LP-Filter
Wp=7/(fs/2);    % Pass-band edge freq
Ws=12/(fs/2);   % Stop-band edge freq
Rp=1;           % Pass-band ripple
Rs=60;          % Stop-band attenuation
[N3,Wn]=cheb1ord(Wp,Ws,Rp,Rs);       
[B3,A3]=cheby1(N3,Rp,Wp,'low');

figure 
freqz(B3,A3,[0:1:70],fs)
title('Chebyshev LP filter');

%-----------------------Filtering
y3=zeros(length(var),length(t));
Sy3=zeros(D,length(var));
for i=1:length(var)
    y3(i,:)=filter(B3,A3,x(i,:));
    [Sy3(:,i),f]=pwelch(y3(i,:),hamming(D),n_overlap,D,fs,'centered');
end

figure; hold on;
plot(f,10*log10(Sx)); plot(f,10*log10(Sy3(:,1)));
xlabel('f/Hz'); ylabel('E\{S(f)\}/dB');
title('Estimated PSD S_X(f) and S_{Y_3}(f) - Chebyshev Filter')
legend('S_X(f)','S_{Y_3}(f)')

%-----------------------
color1=[0.3010, 0.7450, 0.9330];

figure
subplot(1,3,1); plot(t,x(1,:),'Color',color1); hold on; plot(t,y3(1,:),'k');
axis([0 4 -10 10])
xlabel('t/s'); ylabel('amplitude'); title('\sigma^2=10');
legend('X(t)','Y_3(t)');
subplot(1,3,2); plot(t,x(2,:),'Color',color1); hold on; plot(t,y3(2,:),'k');
axis([0 4 -10 10])
xlabel('t/s'); ylabel('amplitude'); title('\sigma^2=1');
legend('X(t)','Y_3(t)');
subplot(1,3,3); plot(t,x(3,:),'Color',color1); hold on; plot(t,y3(3,:),'k');
axis([0 4 -10 10])
xlabel('t/s'); ylabel('amplitude'); title('\sigma^2=0.1');
legend('X(t)','Y_3(t)');
