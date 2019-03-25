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
Ad = exp_expand(A,Ts,100);
Ad_ = (exp(1))^(A*Ts);
Bd = A^-1*(Ad-I)*B;
Cd = C;
Dd = D;

sys_ssd = ss(Ad,Bd,Cd,Dd,Ts);

%% Simulation

t_end = 10;
t = linspace(0, t_end, t_end*Fs + 1);
u_sin = sin(t*f0);
u_step = ones(size(t))*F;
u_impulse = zeros(size(t)); u_impulse(1) = F;

u = u_impulse;
y_tf  = lsim(sys_tf,  u, t);
y_ss  = lsim(sys_ss,  u, t);
y_ssd = lsim(sys_ssd, u, t);

%% Markov params
y_markov = markov_params(Ad,Bd,Cd,Dd,size(t));

%% ERA
H0 = get_hankel(y_markov, 2, 2);
H1 = get_hankel(y_markov, 2, 2, true);
[P,S,Q] = svd(H0);
PS = P*S^(1/2);
SQ = S^(1/2)*Q';

C_era = PS(1,:);
B_era = SQ(:,1);
A_era = S^(-1/2)*P'*H1*Q*S^(-1/2);
y_markov_era = markov_params(A_era,B_era,C_era,0,size(t));
