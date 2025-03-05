clear all;
M_4 = 0.335; %kg
M_l = 0.065; %kg

J_l_cog = 8.74e-5; %kg/m2
J_l_piv = 4.41e-4; %kg/m2
J_4 = 1.49e-3; %kg/m2
J_4m = 3.59e-3; %kg/m2

J_motor_side = 3.9e-7 + 7.06e-8 + 2.087e-3;

%% Link Geo
L_link = 0.127; %m
L_bar = 0.13; %m
W_bar = 0.01; %m
H_bar = 0.002; %m
piv_to_cog = L_link/2;  %m

% sanity check

J_l_pivot_steiner = J_l_cog + M_l * piv_to_cog^2

%% Motor
La = 0.18e-3;
Km = 7.68e-3; % V/(rad/s)
Ra = 2.6;