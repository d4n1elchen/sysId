function y=markov_params(A,B,C,D,msize)
    y=zeros(msize);
    order=max(msize)-1;
    y(1) = D;
    for i=1:order
        y(i+1) = C*A^(i-1)*B;
    end
end