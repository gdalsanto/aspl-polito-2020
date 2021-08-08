% Assignment 2_2 Correlation Functions

close all
clear all
clc

addpath ./functions

T=0.1e-3;                   % sampling period
t=0:T:10;                   % time in s
N=1000;                     % # of signals
S=zeros(N,length(t));       % sinusoidal signals matrix 

% signals generation 

for i=1:1000
    ph=2*pi*rand();         % random phase [0 2*pi]
    if i==1
        ph0=ph;
    end
    S(i,:)=sin(2*pi*i*t+ph);        
end

ph1=2*pi*rand();
p=sin(2*pi*t+ph1);          

% cross-correlation s1-p

[y_val,x_val]=xcorr(S(1,:),p);
[y_max,x_max]=max(y_val);
lag=x_val(x_max);           % delay in # of lags

delta_ph_xcorr=360*lag*T;   % detected delay in deg
delta_ph=rad2deg(ph1-ph0);  % actual delay in deg
 
% phase ambiguity correction

if delta_ph>180
        delta_ph_xcorr=rem(delta_ph_xcorr+360,360);
else
        delta_ph_xcorr=rem(delta_ph_xcorr-360,360);
end  

error_ph=rem(delta_ph_xcorr-delta_ph,360);   % phase error

figure
subplot(1,2,1); plot(t,S(1,:)); hold on; plot(t,p);
xlabel('time/s'); ylabel('amplitude');
axis([0 10 -inf inf]);
legend('s_1(t)','p(t)');
subplot(1,2,2); plot(x_val,y_val);
xlabel('lag/samples'); ylabel('amplitude');
sgtitle('Cross-correlation between s_1(t) and p(t)');


%% 

M=3;                        % # of signals 
Sa=zeros(M,length(t));      % sums of sinusoidal signals matrix 

error_ph_2=zeros(1,M);      % phase error vector 

for i=1:M
    Sa(i,:)=S(1,:);
    for k=2:10^i
        Sa(i,:)=Sa(i,:)+S(k,:);
    end     
end

figure
for k=1:M    
    
    [y_val,x_val]=xcorr(Sa(k,:),p);
    [y_max,x_max]=max(y_val);
    lag=x_val(x_max);
    
    subplot(2,3,(3+k)); plot(x_val,y_val);
    axis([-inf inf -6e5 6e5]);
    xlabel('lag/samples'); ylabel('amplitude');
    
    delta_ph_xcorr=rem(360*lag*T,360);   % detected delay in deg
    
    % phase ambiguity correction

    if delta_ph>180
        delta_ph_xcorr=rem(delta_ph_xcorr+360,360);
    else
        delta_ph_xcorr=rem(delta_ph_xcorr-360,360);
    end 
  
    error_ph_2(1,k)=rem(delta_ph_xcorr-delta_ph,360);
end

subplot(2,3,1); plot(t,Sa(1,:)); hold on; plot(t,p);
axis([0 10 -inf inf]);
title('n=10'); xlabel('time/s'); ylabel('amplitude');
legend('s_a(t)','p(t)');

subplot(2,3,2); plot(t,Sa(2,:)); hold on; plot(t,p);
axis([0 10 -inf inf]);
title('n=100'); xlabel('time/s'); ylabel('amplitude');
legend('s_a(t)','p(t)');

subplot(2,3,3); plot(t,Sa(3,:)); hold on; plot(t,p);
axis([0 10 -inf inf]);
title('n=1000'); xlabel('time/s'); ylabel('amplitude');
legend('s_a(t)','p(t)');

sgtitle('Cross-correlation between s_a(t) and p(t)');

