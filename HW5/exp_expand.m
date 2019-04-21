function Ad = exp_expand(A, Ts, order)
Ad = eye(2);
for i=1:order
    Ad = Ad + (A*Ts)^i/factorial(i);
end
end