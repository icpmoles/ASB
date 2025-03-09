function [m11, m12, m21, m22, error] = mass_jacobian(x,y,debug)
% mass_jacobian see pdf
% given xy coordinates, it returns the mass jacobian
% seen by the load 
% if debug true, it also prints it
% error = true means an error somewhere
[a1,a2,p1,p2, error] = inverse_kin(x,y, false);

L =0.127;
m = 0.065;
J_l_cog = 8.74e-5;
J_motor_side = 3.9e-7 + 7.06e-8 + 2.087e-3;
Jp = J_l_cog;
Ja = Jp + (70^2)*J_motor_side;
mph = diag([m,m,Ja,m,m,Jp,m,m,Jp,m,m,Ja]);

if not(error)
g11 = sin(a1-a2)/sin(p1-p2);
g12 = sin(p2-a2)/sin(p1-p2);
g21 = sin(a1-p1)/sin(p1-p2);
g22 = sin(p1-p2)/sin(p1-p2);

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

m0 = Lm'*mph*Lm;
m11 = m0(1,1);
m12 = m0(1,2);
m21 = m0(2,1);
m22 = m0(2,2);

if debug
Lm
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

