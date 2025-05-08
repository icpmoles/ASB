%% MOTOR
k = 7.68e-3; %motor constant
eta_m = 0.69;  % efficency motor
Ra = 2.6; % armature resistance
La = 0.18e-3; %armature inductance


M_4 = 0.335; %kg Mass of 4 LINKs
M_l = 0.065; %kg Mass of LINK
r = 70;
eta_g = 0.9;   % efficency gearbox

J_l_cog = 8.74e-5; % Inertia Link Center of Gravity
J_l_piv = 4.41e-4; % Inertia Link PIVOT
J_4 = 1.49e-3;     % Inertia of 4 links as seen by the load shaft (from DS)
J_4m = 3.59e-3; %kg/m2 % Inertia of 4 links as seen by the load shaft + motor + gears

% External load inertia seen by the load shaft on mot 0/1 in the home position (analytically)
J00_ext_home = 0.0017473775; 
J11_ext_home = 0.0017473775;
J_load_ext_home = J00_ext_home;
% Average total inertia of arm + gears + motor on load shaft 0/1 (analytically)
J00_av =  0.005530275769417; 
J11_av =  0.006472019250083; 


J_eq_ds =  2.087e-3; %kg/m2 High-gear equivalent moment of inertia without external load from datasheet
J_motor_side = 3.9e-7 + 7.06e-8; % Rotor + Tach

%% Gears
m24 = 0.005;
m72 = 0.03;
m120 = 0.083;

r24 = 6.35e-3;
r72 = 0.019;
r120 = 0.032;

I24 = 0.5 * m24 * r24^2;
I72 = 0.5 * m72 * r72^2;
I120 = 0.5 * m120 * r120^2;

Jg_eq = 2*I72 + I120 + I24*(5^2);  % 5.5846e-05


% Jg_eq = 5.5846e-05; % equivalent moment of inertia of gears.
%% Nominal model


J_eq_nom =  (J_motor_side * r^2 + (Jg_eq + J_4)/eta_g)/eta_m; % from datasheet

BETA_nom = 15e-3;
B_eq_nom = BETA_nom /(eta_m*eta_g) +  r^2 *k^2 /Ra;
tau_nom = J_eq_nom/B_eq_nom;
P_nom = 1/tau_nom;
%% Link Geo
L_link = 0.127; %m
L_bar = 0.13; %m
W_bar = 0.01; %m
H_bar = 0.002; %m
piv_to_cog = L_link/2;  %m

% sanity check

J_l_pivot_steiner = J_l_cog + M_l * piv_to_cog^2;

%% Motor
La = 0.18e-3;
Km = 7.68e-3; % V/(rad/s)
Ra = 2.6;

%% Estimated (From NominalModel.mlx)

mu_ext = [1.4479 1.4684];
P_ext = [24.9218 24.4398];
tau_ext = [1/24.9218 1/24.4398];
beta_ext = [ 0.026532057000485 0.024683842701485];

Jl_eq = Jg_eq + J_load_ext_home;

J_tilda = ((Jl_eq/eta_g) + r^2 * J_motor_side)/eta_m;
