% Assignment 2_1 Correlation Functions

close all
clear all
clc

addpath ./functions  
%% autocorrelation

N=50;                       % number of samples of x
T=5;                        % period of x
xp=[1 2 3 5 8];             % signal x periodic sequence
x=zeros(1,3*N-1);   

for i=(N+1):T:((2*N+1)-T)   
    x(i:(i+(T-1)))=xp;      % periodic signal x starts at position N+1, until 2*N
end

% iterative procedure 

Rxx=zeros(1,((2*N)-1));   	% autocorrelation vector 
Mem=zeros(1,N);

for n=(-N+1):(N-1)
    for k=1:N
        d=k+N-n;
        Mem(k)=x(k+N).*x(d);
    end
    Rxx(n+N)=sum(Mem);
end

stem(1:N,x((N+1):2*N));
title('x[n]'); xlabel('n'); ylabel('amplitude');

figure
subplot(1,3,1); stem((-N+1):(N-1),Rxx);
title('R_{xx}[n] iterative procedure'); xlabel('lag/samples'); ylabel('amplitude');

% xcorr function
Rxx_2=xcorr(x((N+1):2*N),x((N+1):2*N));
subplot(1,3,2); stem(-49:49,Rxx_2)
title('R_{xx}_2[n] xcorr'); xlabel('lag/samples'); ylabel('amplitude');

% conv function 
Rxx_3=conv(x((N+1):2*N),flip(x((N+1):2*N)));
subplot(1,3,3); stem(-49:49,Rxx_3);
title('R_{xx}_3[n] conv'); xlabel('lag/samples'); ylabel('amplitude');

sgtitle('Autocorrelations');

% error check
error_1=(sum(Rxx.^2)/sum(Rxx_2.^2)-1)*100;
error_2=(sum(Rxx.^2)/sum(Rxx_3.^2)-1)*100;
isequal(Rxx,Rxx_2)
isequal(Rxx,Rxx_3)

%% cross-correlation

M=80;                       % number of samples of y
T=10;                       % period of y
yp=[1 2 3 5 8 13 21 34 55 89];  % signal y periodic sequence
y=zeros(1,3*M-1);           

for i=(M+1):T:((M+1)-T+M)
    y(i:(i+(T-1)))=yp;      % periodic signal y starts at position M+1, until 2*M
end

% iterative procedure 

Rxy=zeros(1,M+N-1);         % cross correlation vector
Mem=zeros(1,N);

for n=(-M+1):(N-1)
    for k=1:M
        d=k-n+M;
        Mem(k)=x(k+N).*y(d);
    end
    Rxy(n+M)=sum(Mem);
end

figure
stem(1:M,y((M+1):2*M));
title('y[n]'); xlabel('n'); ylabel('amplitude');

figure
subplot(1,3,1); stem(-79:49,Rxy);
title('R_{xy}[n] iterative procedure'); xlabel('lag/samples'); ylabel('amplitude');
axis([-79 inf  0 inf])


% xcorr function
Rxy_2=xcorr(x((N+1):2*N),y((M+1):2*M));
subplot(1,3,2); stem(-79:79,Rxy_2)
title('R_{xy}_2[n] xcorr'); xlabel('lag/samples'); ylabel('amplitude');
axis([-inf inf  0 inf])

% conv function
Rxy_3=conv(x((N+1):2*N),flip(y((M+1):2*M)));
subplot(1,3,3); stem(-79:49,Rxy_3)
title('R_{xy}_3[n] conv'); xlabel('lag/samples'); ylabel('amplitude');
axis([-79 inf  0 inf])

sgtitle('Cross-Correlations');

% error detection
error_1=(sum(Rxy.^2)/sum(Rxy_2.^2)-1)*100;
error_2=(sum(Rxy.^2)/sum(Rxy_3.^2)-1)*100;
isequal(Rxy,Rxy_2(1:(N+M-1)))
isequal(Rxy,Rxy_3)

%% properties check 

% autocorrelation - energy
en_x=sum(x.^2);             % energy of signal ex
error_en=(Rxx(N)/en_x-1)*100; 

% cross-correlation - conjugate symmetry
Ryx=conv(y((M+1):2*M),flip(x((N+1):2*N)));

figure
stem(-79:49,flip(Ryx))
hold on 
stem(-79:49,Rxy,'--x')
title('Conjugate symmetry'); xlabel('lag/samples'); ylabel('amplitude');
legend('Ryx[-n]','Rxy[n]');



    