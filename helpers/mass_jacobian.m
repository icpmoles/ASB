function [m11, m12, m21, m22, error] = mass_jacobian(x,y,debug,bias)
% mass_jacobian see pdf
% given xy coordinates, it returns the mass jacobian
% seen by the load 
% if debug true, it also prints it
% error = true means an error somewhere
eta_m = 0.69;
eta_g = 0.9;
r = 70;
Jg = 5.5846e-05;
Jma = 3.9e-7 + 7.06e-8;

[a1,a2,p1,p2, error] = inverse_kin(x,y, false);
conv_factor = 1;
L = 0.127;
m = 0.065/conv_factor;
J_l_cog = 8.74e-5;


% J_l_cog = 4.41e-4;
%J_motor_side = eq motor side + Jgearbox 
% J_motor_Lside = 0.9*(3.9e-7 + 7.06e-8)/(4900) + 2.087e-3;
% J_motor_side = 0;
Jp = J_l_cog; % passive link
Ja = Jp ; %active link + J_motor_Lside
mph_v = [m,m,Ja,m,m,Jp,m,m,Jp,m,m,Ja];
mph = diag(mph_v);
bound_d = 0.02/conv_factor; %% at the singularity it has problems
bound_od = 0.01/conv_factor; %% at the singularity it has problems, off diagonal members


if not(error)
det = -sin(p1-p2);
g11 = sin(a1-p2)/det;
g12 = sin(p2-a2)/det;
g21 = sin(a1-p1)/det;
g22 = sin(p1-a2)/det;

%LINK 1
l1_1 = -L/2 *sin(a1);
l2_1 = L/2 *cos(a1);
l3_1 = 1;

l1_2 = 0;
l2_2 = 0;
l3_2 = 0;

% LINK 2
l4_1= -L *sin(a1) - L/2 *sin(p1) * g11;
l5_1= L *cos(a1) + L/2 *cos(p1) * g11;
l6_1 = g11;

l4_2 = -L *sin(a2) - L *sin(p2) * g22 + L/2 *sin(p1) * g12;
l5_2 =  L *cos(a2) + L *cos(p2) * g22 - L/2 *cos(p1) * g12;
l6_2 = g12;


% LINK 3
l7_1 = -L *sin(a1) - L *sin(p1) * g11 + L/2 *sin(p2) * g21;
l8_1 = L *cos(a1) + L *cos(p1) * g11 - L/2 *cos(p2) * g21;
l9_1 = g21;

l7_2 = -L *sin(a2) - L *sin(p2) * g22 ;
l8_2 =  L *cos(a2) + L *cos(p2) * g22 ;
l9_2 = g22;


% LINK 4

l10_1 = 0;
l11_1 = 0;
l12_1 = 0;

l10_2 = -L/2 * sin(a2);
l11_2 = L/2 * cos(a2);
l12_2 = 1;


Lm = [
l1_1 , l2_1, l3_1 , l4_1,  l5_1 , l6_1, l7_1 , l8_1,  l9_1 , l10_1, l11_1 , l12_1;
l1_2 , l2_2, l3_2 , l4_2,  l5_2 , l6_2, l7_2 , l8_2,  l9_2 , l10_2, l11_2 , l12_2;
]';


m0 = Lm'*mph*Lm ;
m11 = clamp(m0(1,1),bound_d);
m12 = clamp(m0(1,2),bound_od);
m21 = clamp(m0(2,1),bound_od);
m22 = clamp(m0(2,2),bound_d);

if bias
    m11 = ((Jg+m11)/eta_g + Jma*r^2)/eta_m;
    m22 = ((Jg+m22)/eta_g + Jma*r^2)/eta_m;
end


if debug
rad2deg(a1)
rad2deg(a2)
rad2deg(p1)
rad2deg(p2)
Lm
mph_v'
m0
end


else 
    m11 = NaN;
    m12 = NaN;
    m21 = NaN;
    m22 = NaN;
    error = 1;
end

end

