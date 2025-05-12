function [success] = printXYtrajectory(theta_a1,theta_a2)
%PRINTXYTRAJECTORY Summary of this function goes here
%   Detailed explanation goes here

n_points = size(theta_a1,2);
x = zeros(n_points,1);
y = zeros(n_points,1);
for i = 1:n_points
    [x(i), y(i), ~ , ~, ~] = direct_kinematics(theta_a1(i),theta_a2(i));
end
x = x* 100;
y = y* 100;

plot(x,y)
ylabel("y (cm)")
xlabel("x (cm)")
xlim([0 2*12.7])
ylim([0 sqrt(3)*12.7])
axis equal