% Discrete Fourier Transform 
% x <- signal vector
% N <- number of samples of the input sequence
% X_k -> resulting DFT 
%        frequency range [-N/2:N/2]

function X_k = my_DFT(x,N)
    n=[0:(N-1)];                
    k=[0:(N-1)];
    X_k=zeros(1,length(k));         % DTF vector
    for h = 1:N                     % index of k[]
            X_k(h)=sum(x.*exp(-j*2*pi*n.*(k(h)/N)));
    end
    X_k=circshift(X_k,floor(N/2));  % frequency rearrangement 
end
