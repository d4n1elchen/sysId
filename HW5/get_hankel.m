function H=get_hankel(SMP, alph, beta, shift)
    SMP = SMP(2:end);
    H=zeros(alph, beta);
    if nargin < 4
      shift = false;
    end
    if shift
        if length(SMP) < (alph+beta)
            error('Size of pulse response is not enough');
        end
        for a=1:alph
            for b=1:beta
                H(a, b) = SMP(a+b);
            end
        end
    else
        if length(SMP) < (alph+beta-1)
            error('Size of pulse response is not enough');
        end
        for a=1:alph
            for b=1:beta
                H(a, b) = SMP(a+b-1);
            end
        end
    end
end