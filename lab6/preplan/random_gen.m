fs = 500;

omega_res_des = 0.5; %rad/s
f_res_des = omega_res_des/(2*pi);
N_samp = fs/f_res_des;

T_samp = N_samp/fs; % 12s -> approx to 15s 

t = [0:0.1:15];
l = size(t,2);

rng(123456,"twister");
s = (2*rand(1,l)-1);

wn = [t; s];
plot(wn(1,:),wn(2,:))