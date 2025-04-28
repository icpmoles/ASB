function [alpha_dot] = jacobian_vf_projection(t_a1,t_a2,vx,vy)
%JACOBIAN_VF_PROJECTION Projection of v onto angle velocity
%   Detailed explanation goes here
% t_a2 = t_a2; %% matlab functions all measure angle compared to x axis
v = [vx;vy];
[~, ~, t_p1 , t_p2, ~] = direct_kinematics(t_a1,t_a2);
M = vel_jacobian(t_a1,t_a2,t_p1,t_p2);

alpha_dot = (M' * M)\M' * v;

end

