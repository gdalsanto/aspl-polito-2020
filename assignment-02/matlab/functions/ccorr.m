%% circular correlation function
% x -> valus of the cross correllation function
% n -> lags [-N:N-1] with N=length of the longest vector 
% for auto correlation input the sequence twice: ccorr(a,a)
% a,b must be row vectors

function  [x,n] = ccorr(a,b)
    if length(a)~=length(b)
        if length(a)>length(b)
            b=[b zeros(1,length(a)-length(b))];
        else
            a=[a zeros(1,length(a)-length(b))];
        end
        disp('input vectors with different length -> zero padding');
    end
    
    N=length(a);
    x=zeros(1,2*N-1);
    for d=0:(2*N-1)
        x(d+1)=1/N*sum(a.*circshift(b,d));
    end
    n=-N:(N-1);
end

