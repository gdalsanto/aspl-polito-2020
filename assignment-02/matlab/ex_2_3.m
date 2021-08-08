% Assignment 2_3 Correlation Functions and BER

close all
clear all
clc

addpath ./functions

N=1000;                     % # of samples
K=50;                       % # of repetitions 
noise_std=[0.1 0.5 1 5 10 20 30];   % standard deviation values
M=length(noise_std);

xp=randi([0 1],1,N);        % random sequence of bit 
x=xp;

% initializations 

err_bit1=zeros(M,K);        % total # of errors  
err_bit2=zeros(M,K);
BER1=zeros(M,K);            % Bit Error Rate
BER2=zeros(M,K);
BER1_count=zeros(1,M);      % # of BER>0 
BER2_count=zeros(1,M);  

for m=1:M
    for k=1:K
        noise=noise_std(m).*randn(1,N);     % normal distributed noise
        y=x+noise;
        delay=randi([-1000 1000]);
        x1=circshift(x,delay);
        y1=circshift(y,delay);   

        % cross-correlation 
        
        [y_val,x_val]=xcorr(y1,x);
        [y_max,x_max]=max(y_val);
        del_xcorr=x_val(x_max);
        
        x2=circshift(x1,-del_xcorr); % delay compensation
        
        if (k==1 && m==1)       
            figure
            subplot(1,3,1); plot(x); hold on; plot(y1)
            xlabel('bit number'); ylabel('amplitude');
            legend('x[n]','y''[n]');
            axis([0 200 -inf inf])
            
            subplot(1,3,2); plot(x); hold on; plot(x1,'--')
            xlabel('bit number'); ylabel('value');
            legend('x[n]','x''[n]');
            axis([0 20 -inf inf])
            
            subplot(1,3,3); plot(x); hold on; plot(x2,'--')
            xlabel('bit number'); ylabel('value');
            legend('x[n]','x"[n]');
            axis([0 20 -inf inf])
        end
        if((k==1 && m==1)||(k==K && m==4))
            figure
            subplot(1,2,1); plot([-(N-1):(N-1)],xcorr(x,y1));
            title('R_{xy''}[n]');  xlabel('lag/samples'); ylabel('amplitude');
            subplot(1,2,2); plot([-(N-1):(N-1)],xcorr(x,x2));
            title('R_{xx"}[n]');  xlabel('lag/samples'); ylabel('amplitude');
            if(k==1 && m==1)
                sgtitle('noise standard deviation: 0.1')
            else
                sgtitle('noise standard deviation: 5')
            end
        end
        % bit error counter 
        
        for i=1:N
            if x(i)~=x1(i)
                err_bit1(m,k)=err_bit1(m,k)+1;
            end
            if x(i)~=x2(i)
                err_bit2(m,k)=err_bit2(m,k)+1;
            end
        end
    end
    BER1=err_bit1/N;
    BER2=err_bit2/N;
    for i=1:K
        if BER1(m,i)>0
            BER1_count(m)=BER1_count(m)+1;
        end
        if BER2(m,i)>0
            BER2_count(m)=BER2_count(m)+1;
        end
    end
end

figure
plot(noise_std,BER2_count);
xlabel('Noise Standard Deviation');ylabel('number of BER>0');

%% periodic x

T=5;            % sequence period 
N=T*1000;
x=[xp xp xp xp xp];         % replicated version of the previously generated x 

% initialization of the counters

err_bit1=zeros(M,K);
err_bit2=zeros(M,K);
BER1=zeros(M,K);
BER2=zeros(M,K);
BER1_count=zeros(1,M);
BER2_count=zeros(1,M);

for m=1:M
    for k=1:K
        noise=noise_std(m).*randn(1,N);
        y=x+noise;
        delay=randi([-1000 1000]);
        x1=circshift(x,delay);
        y1=circshift(y,delay);

        [y_val,x_val]=xcorr(y1,x);
        [y_max,x_max]=max(y_val);
        del_xcorr=x_val(x_max);
        
        x2=circshift(x1,-del_xcorr);
        
        if((k==1 && m==1)||(k==K && m==4))
            figure
            subplot(1,2,1); plot([-(N-1):(N-1)],xcorr(x,y1));
            title('R_{xy''}[n]');  xlabel('lag/samples'); ylabel('amplitude');
            subplot(1,2,2); plot([-(N-1):(N-1)],xcorr(x,x2));
            title('R_{xx"}[n]');  xlabel('lag/samples'); ylabel('amplitude');
            if(k==1 && m==1)
                sgtitle('noise standard deviation: 0.1')
            else
                sgtitle('noise standard deviation: 5')
            end
        end

        for i=1:N
            if x(i)~=x1(i)
                err_bit1(m,k)=err_bit1(m,k)+1;
            end
            if x(i)~=x2(i)
                err_bit2(m,k)=err_bit2(m,k)+1;
            end
        end
    end
    BER1=err_bit1/N;
    BER2=err_bit2/N;
    for i=1:K
        if BER1(m,i)>0
            BER1_count(m)=BER1_count(m)+1;
        end
        if BER2(m,i)>0
            BER2_count(m)=BER2_count(m)+1;
        end
    end
end

figure
plot(noise_std,BER2_count);
xlabel('Noise Standard Deviation');ylabel('number of BER>0');



