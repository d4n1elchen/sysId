function dydt = getODEfun(t,y,A,B,u,t_span)
    dydt = A*y + B*interp1(t_span,u,t);
end