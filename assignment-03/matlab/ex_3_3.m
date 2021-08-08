% Assignment 3 - Effect of zero padding on DTFT

close all
clear all
clc

addpath ./functions

N=15;                   % number of samples of x
M=(N+1)/2;              
K=4;                    % not normalized height 
x1=K*ones(1,M)/M;       % rect sequence
x=conv(x1,x1);          % traing sequence - max height K^2/M

X=fftshift(fft(x));
f=[-N/2:(N/2-1)]/N;

%-----------------------DFT-N=15
figure 
subplot(2,3,1); stem(x);                   
xlim([1 N]);
xlabel('n/samples'); ylabel('amplitude'); title('N=15');
subplot(2,3,4); plot((f+1/(2*N)),abs(X))  
ylim([0 20]);
xlabel('f/Hz'); ylabel('amplitude'); title('N=15');

%-----------------------DFT-N=64
N1=64;
x1=[x zeros(1,N1-N)];   % zero-padding  
subplot(2,3,2); stem(x1);                   
xlim([1 N1]);
xlabel('n/samples'); ylabel('amplitude'); title('N=64');
X1=fftshift(fft(x1));
f=[-N1/2:(N1/2-1)]/N1;
subplot(2,3,5); plot(f,abs(X1))
xlabel('f/Hz'); ylabel('amplitude'); title('N=64');

%-----------------------DFT-N=128
N2=128;
x2=[x zeros(1,N2-N)];
subplot(2,3,3); stem(x2);                   
xlim([1 N2]);
xlabel('n/samples'); ylabel('amplitude'); title('N=128');
X2=fftshift(fft(x2));
f=[-N2/2:(N2/2-1)]/N2;
subplot(2,3,6); plot(f,abs(X2))
xlabel('f/Hz'); ylabel('amplitude'); title('N=128');

sgtitle('Zero-padding analysis on x[n] and |X(k)|')

%-----------------------DTFT

X_DTFT=K^2*(sin(M*pi*f).^2)./(M^2.*sin(pi*f).^2);
X_DTFT(ceil(N2/2)+1)=K^2;                   % adjustment of the indeterminate form  
figure
plot(f,abs(X_DTFT),'r');
hold on;
stem(f(1:2:128),abs(X1));stem(f,abs(X2),'-xb');
xlabel('f/Hz'); ylabel('amplitude'); title('X(e^{j2\pi f}), X(k)');
legend('|X(e^{j2\pi f})|','|X(k)|, N=64','|X(k)|, N=128')

