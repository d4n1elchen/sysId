clear; clc;

m = 0.1;
k = 100;
F = 1;

f0 = sqrt(k/m);
Fs = f0*10;

%% Transfer function model

% Use symbol 's' to construct the tf
% s = tf('s');
% sys_tf = 1/(m*s^2+k)

num = [1];
den = [m 0 k];

sys_tf = tf(num,den);

%% State space model

A = [0 1; -k/m 0];
B = [0 1/m]';
C = [1 0];
D = [0];

sys_ss = ss(A,B,C,D);

%% Discrete-time state space model

I = eye(2);
Ts = 1/Fs;
Ad = I + A*Ts + A^2*Ts^2/2 + A^3*Ts^3/6; % Ordered 3
Bd = A^-1*(Ad-I)*B;
Cd = C;
Dd = D;

sys_ssd = ss(Ad,Bd,Cd,Dd,Ts);

%% Simulation

t_end = 100;
t = linspace(0, t_end, t_end*Fs + 1);
u_sin = sin(t*f0);
u_step = ones(size(t))*F;
u_impulse = zeros(size(t)); u_impulse(1) = F;

u = u_impulse;
y_tf  = lsim(sys_tf,  u, t);
y_ss  = lsim(sys_ss,  u, t);
y_ssd = lsim(sys_ssd, u, t);

%% Plot result

figure(1);

subplot(4, 1, 1);
plot(t, u);
title('Input signal');
grid;

subplot(4, 1, 2);
plot(t, y_ss);
title('Continuous-time state space model');
grid;

subplot(4, 1, 3);
plot(t, y_ssd);
title('Discrete-time state space model');
grid;

subplot(4, 1, 4);
plot_fft(y_ss, Fs);
title('FFT');
grid;
