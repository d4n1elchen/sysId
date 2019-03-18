function plot_fft(signal, Fs)
    L = size(signal,1);
    Y = abs(fft(signal));
    P = Y(1:L/2+1);
    f = Fs*(0:(L/2))/L * (2*pi);
    [max_f_mag, max_f_idx] = max(P);
    max_f = f(max_f_idx);
    plot(f,P);
    text(max_f+max_f*0.1, max_f_mag-max_f_mag*0.1, [num2str(max_f), ' Hz']);
end