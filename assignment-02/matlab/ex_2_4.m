% Assignment 2_4 Gold sequencies

close all
clear all
clc

addpath ./functions

% x^6+x^1+1         selected primitive polinomial

n=6;                % degree of the primitive polynomial
N=2^n-1;            % # elements of the m-sequences
in=[1 1 1 1 1 1 ];  % initial values x^1 - x^6
a=zeros(1,N);       % m sequence

% m sequence generation
for i=1:N
    a(i)=mod(in(1)+in(6),2);
    in=circshift(in,1);
    in(1)=a(i);
end

k=2;
q=2^k+1;                % decimation factor 

a_r=repmat(a,1,q);      % replica of a
b=a_r(1:q:end);         % decimated a - a and b preferred pairs 

M=zeros(N,N+2);         % Gold codes matrix
M(:,1)=a';              
M(:,2)=b';

% Gold codes generation
for i=0:(N-1)
    b_d=circshift(b,i); % delayed version of b
    M(:,i+3)=mod(a'+b_d',2);
end

a=2*a-1;            % [0 1] -> [-1 1] 
b=2*b-1;

n=-N:(N-1);
figure 
subplot(1,2,1); plot(n,ccorr(a,a)); hold on; plot(n,ccorr(b,b),'--');
title('Autocorrelations'); xlabel('lag/samples'); ylabel('amplitude'); legend('R_{aa}[n]','R_{bb}[n]');
axis([-inf inf -0.2 1.2])
subplot(1,2,2); plot(n,ccorr(a,b)); 
title('Cross-correlation'); xlabel('lag/samples'); ylabel('amplitude');
sgtitle('Preferred pair correlations');


gs1=2*M(:,4)'-1;            % [0 1] -> [-1 1] 
gs2=2*M(:,60)'-1;

figure
subplot(1,2,1); plot(n,ccorr(gs1,gs1)); 
title('Gold sequences autocorrelation'); xlabel('lag/samples'); ylabel('amplitude');
axis([-inf inf -0.4 1.2])
subplot(1,2,2); plot(n,ccorr(gs1,gs2)); 
title('Gold sequences cross-correlation'); xlabel('lag/samples'); ylabel('amplitude');
sgtitle('Gold sequences correlations');




