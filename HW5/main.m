clear; clc;

m = 0.5;
b = 0.005;
k = 0.5;
F = 1;

wn = sqrt(k/m);
Fs = 1000;
Ts = 1/Fs;

%% State space model

A = [0 1; -k/m -b/m];
B = [0 1/m]';
C = [1 0];
D = [0];

sys_ss = ss(A,B,C,D);

%% Discrete-time state space model

I = eye(2);
Ad = exp_expand(A,Ts,100);
Ad_ = (exp(1))^(A*Ts);
Bd = A^-1*(Ad-I)*B;
Cd = C;
Dd = D;

sys_ssd = ss(Ad,Bd,Cd,Dd,Ts);

%% Simulation
t_end = 1000;
t = linspace(0, t_end, t_end*Fs + 1);
t_size = size(t);
t_size_fh = [1 ceil(t_size(2)/2)];
t_size_lh = [1 ceil(t_size(2)/2)-1];

f_sin = 100;
u_sin =  [sin(t(1:t_size_fh(2))*f_sin)*F zeros(t_size_lh)];
u_step = [ones(t_size_fh)*F zeros(t_size_lh)];
u_impulse = zeros(t_size); u_impulse(1) = F;
u_rand = [(rand(t_size_fh)-0.5)*F zeros(t_size_lh)];

u = u_rand;
y_ss  = lsim(sys_ss, u, t);
y_ssd = lsim(sys_ssd, u, t);

%% Markov params
y_markov = markov_params(Ad,Bd,Cd,Dd,size(t));

%% FRF
N = 10;
frf_sum = 0;
for i=1:N
    u_rand = [(rand(t_size_fh)-0.5)*F zeros(t_size_lh)];
    y_rand  = lsim(sys_ss, u_rand, t);
    if(i==1)
        frf_sum = fft(y_rand')./fft(u_rand);
    else
        frf_sum = frf_sum + fft(y_rand')./fft(u_rand);
    end
end
frf_avg = frf_sum / N;
y_frf = ifft(frf_avg);

%% ERA
% Estimate order
H0 = get_hankel(y_markov, 10, 10);
H1 = get_hankel(y_markov, 10, 10, true);
[P,S,Q] = svd(H0);
Sv = diag(S);
Sv = Sv/Sv(1);
N = sum(Sv>0.01);

P = P(:,1:N);
S = S(1:N,1:N);
Q = Q(:,1:N);

PS = P*S^(1/2);
SQ = S^(1/2)*Q';

C_era = PS(1,:);
B_era = SQ(:,1);
A_era = (S^(-1/2)*P')*H1*(Q*S^(-1/2));
y_markov_era = markov_params(A_era,B_era,C_era,D,size(t));

%% ERA Simulation
sys_era = ss(A_era,B_era,C_era,D,Ts);
y_era = lsim(sys_era,u,t);

%% Eigenvalue of A_era
[P,L] = eig(A_era);
Lv = diag(L);
Lv_c = 1/Ts*log(Lv);

%% Calc damping ratio and natual freq
r = real(Lv_c(1));
theta = imag(Lv_c(1));

wn_est = sqrt(theta^2 + r^2);
b_est = -2*r*m;

%% Plot
plot_results;
