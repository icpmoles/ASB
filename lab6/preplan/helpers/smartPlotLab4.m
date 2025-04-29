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
   n_row = 4;
else
   n_row = 3;
end

%%

% first row: position 0 & 1
figure
subplot(n_row,2,1)
sgtitle(filename)
plot(t,y0,"r:o");
title("angle 0")
ylabel("deg")
% scatter(t,y1,"bd");
if n >= 10
    hold on
    y_ref0 = rad2deg(data(10,:));
    plot(t,y_ref0,"r");
    legend(["theta_0","ref_0"])
    hold off
else
    legend(["theta_0"])
end


subplot(n_row,2,2)
plot(t,y1,"b:o");
title("angle 1")
ylabel("deg")

if n >= 10
    hold on
    y_ref1 = rad2deg(data(11,:));
    plot(t,y_ref1,"b");
    legend(["theta_1","ref_1"])
    hold off
else
    legend(["theta_1"])
end

%% %second row: Control

subplot(n_row,2,3)
plot(t,u0,"r");
title("Control 0")
hold on
plot(t,u0_sat,"r:o");
legend(["U_0","sat_0"])
ylabel("V")
ylim([-10.5 10.5]);
hold off

subplot(n_row,2,4)
plot(t,u1,"b");
title("Control 1")
hold on
plot(t,u1_sat,"b:o");
legend(["U_1","sat_1"])
ylabel("V")
ylim([-10.5 10.5]);
hold off


%%

%second to last: disturbance
if n >= 12
    d0 = data(12,:);
    d1 = data(13,:);
    subplot(n_row,2,5)
    plot(t,d0);
    legend(["d0"]);
    ylabel("V")
    title("Disturbances")
    subplot(n_row,2,6)
    plot(t,d1);
    legend(["d1"]);
    ylabel("V")
end


%last: error codes


subplot(n_row,2,2*n_row-1:2*n_row)
plot(t,e0,"r--");
title("Error")
hold on
plot(t,e1,"b:");
hold off
ylim([-0.5 2.5]);
legend(["e0","e1"]);

