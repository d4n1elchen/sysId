rr = 6; cc = 1;

%% Plot result
figure(1);

subplot(rr, cc, 1);
plot(t, u);
title('Input signal');
grid;

subplot(rr, cc, 2);
plot(t, y_ss);
title('Continuous-time state space model');
grid;

subplot(rr, cc, 3);
plot(t, y_ssd);
title('Discrete-time state space model');
grid;

subplot(rr, cc, 4);
plot(t, y_ssd-y_ss);
title('Error between conti and discrete');
grid;

subplot(rr, cc, 5);
plot(t, y_frf);
title('FRF');
grid;

subplot(rr, cc, 6);
plot(t, y_markov_era);
title('Markov of ERA result');
grid;