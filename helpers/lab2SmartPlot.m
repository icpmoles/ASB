function [isProper] = lab2SmartPlot(data,filename)
% rows:
% 1 = timestamps
% 2 = encoder 0
% 3 = encoder 1
% 4 = motor Volt 0
% 5 = motor Volt 1
Ts = 0.002;
t = data(1,:); % get timeline

if abs(data(2,2)) > abs(data(3,2)) 
    motorId = 0;
else
    motorId = 1;
end

if size(data,1)>6 % we have a sinusoidal signal
    isProper = 1;
    omega = data(6,1);
    A = data(7,1);
    figure;
    subplot(2,1,1)
        hold on;
        plot(t ,data(2,:)/(2048/pi));
        plot(t ,data(3,:)/(2048/pi));
        ylabel("rad");
        xlabel("time (s)");
        hold off
        sgtitle(filename,'Interpreter','none');
        title('Encoders');
        subtitle("Motor"+motorId+" at: " + A + "V & "+ omega + "rad/s" );
        legend(["Enc 0","Enc 1"],'Location','northwest');
        hold off
    subplot(2,1,2); 
        hold on;
        plot(t ,data(4,:));
        plot(t ,data(5,:));
        ylabel("V");
        xlabel("time (s)");
        hold off
        title('Motor Inputs');
        legend(["M 0","M 1"],'Location','northwest');
else
    isProper = 0;
end


end