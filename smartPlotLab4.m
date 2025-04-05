function [n] = smartPlotLab4(data,filename)
% rows:
% 1 = timestamps
% 2 = encoder 0
% 3 = encoder 1
% 4 = motor Volt 0
% 5 = motor Volt 1
n = size(data,1);
t = data(1,:); % get timeline
y0 = rad2deg(data(2,:));
y1 = rad2deg(data(3,:));
u0 = data(4,:);
u1 = data(5,:);
u0_sat = data(6,:);
u1_sat = data(7,:);
e0 = data(8,:);
e1 = data(9,:);


if n >= 12
   n_fig = 4;
else
   n_fig = 3;
end
% first: position
figure
subplot(n_fig,1,1)
sgtitle(filename)
plot(t,y0);
title("Angle (deg)")
hold on
plot(t,y1);
if n >= 10
    y_ref0 = rad2deg(data(10,:));
    y_ref1 = rad2deg(data(11,:));
    plot(t,y_ref0);
    plot(t,y_ref1);
    legend(["theta_0","theta_1","ref_0","ref_1"])
else
    legend(["theta_0","theta_1"])
end
hold off

%second: Control
subplot(n_fig,1,2)
plot(t,u0);
title("Control (V)")
hold on
plot(t,u1);
plot(t,u0_sat);
plot(t,u1_sat);
legend(["U_0","U_1","sat_0","sat_1"])
hold off

%second to last: disturbance
if n >= 12
    d0 = data(12,:);
    d1 = data(13,:);
    subplot(n_fig,1,3)
    plot(t,d0);
    title("Disturbance (V)")
    hold on
    plot(t,d1);
    hold off
    legend(["d0","d1"]);
end


%last: error codes


subplot(n_fig,1,n_fig)
title("Error")
stem(t,e0);
hold on
stem(t,e1);
hold off
ylim([-0.5 2.5]);
legend(["e0","e1"]);

