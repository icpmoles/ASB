clear all
syms L positive
syms ta1 
syms ta2 

assume(ta1>-0.01 | ta1<0.01)
assume(ta2>-0.01 | ta2<0.01)
% from 1 to 3 seen by A1
syms xp1(ta1)
syms yp1(ta1)
syms xp2(ta1,ta2)
syms yp2(ta1,ta2)
syms xp3(ta1,ta2)
syms yp3(ta1,ta2)
% from 4 to 2 seen by A2
syms xp2_2(ta1,ta2)
syms yp2_2(ta1,ta2)
syms xp3_2(ta1,ta2)
syms yp3_2(ta1,ta2)
syms xp4_2(ta1,ta2)
syms yp4_2(ta1,ta2)

xp1(ta1) = (L/2) * cos(ta1);
yp1(ta1) = (L/2) * sin(ta1);

syms tp1(ta1,ta2)  % theta p1 moved by A1 given the ta1 ta2 coordinates

syms bp1(ta1,ta2)  % beta p1 moved by A1 given the ta1 ta2 coordinates


syms ap1(ta1,ta2)  % alpha p1 moved by A1 given the ta1 ta2 coordinates

syms d12(ta1,ta2)  % alpha p1 moved by A1 given the ta1 ta2 coordinates

syms dx_12(ta1,ta2) % delta x_12 
syms dy_12(ta1,ta2)  % delta y_12 

dx_12(ta1,ta2) = L * ( 2 -cos(ta1) +cos(ta2) );
dy_12(ta1,ta2) = L * (-sin(ta1)+sin(ta2));
d12(ta1,ta2) = sqrt(dy_12(ta1,ta2)^2+dx_12(ta1,ta2)^2);
bp1(ta1,ta2) = acos(d12(ta1,ta2)/(2*L));
ap1(ta1,ta2) =  atan(dy_12(ta1,ta2),dy_12(ta1,ta2));
 
tp1(ta1,ta2) = bp1(ta1,ta2) + ap1(ta1,ta2);
xp2(ta1,ta2) = (L/1) * cos(ta1) + (L/2) * cos(tp1(ta1,ta2)) ;
yp2(ta1,ta2) = (L/1) * sin(ta1) + (L/2) * sin(tp1(ta1,ta2)) ;

%%
L14 = diff(xp2,ta1);
L15 = diff(yp2,ta1);
L16 = diff(tp1,ta1);