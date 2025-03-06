function [isProper] = smartPlotEncVoltage(data,filename)
% rows:
% 1 = timestamps
% 2 = encoder 0
% 3 = encoder 1
% 4 = motor Volt 0
% 5 = motor Volt 1
Ts = 0.002;
CheckTime = 1.5;
CheckIndex = int32(CheckTime/Ts);
if size(data,1)>3 && size(data,2)>CheckIndex

    isProper = true;
    
    if abs(data(4,CheckIndex)) > abs(data(5,CheckIndex))
        motorId = 0;
    else 
        motorId = 1;
    end
    
    motorV = data(4+motorId,CheckIndex);
    
    
    figure
    subplot(2,1,1);
        hold on;
        plot(data(1,:),data(2,:)/(2048/pi));
        plot(data(1,:),data(3,:)/(2048/pi));
        ylabel("rad");
        xlabel("time (s)");
        hold off
        sgtitle(filename,'Interpreter','none');
        title('Encoders');
        subtitle("Motor"+motorId+" at: " + motorV + "V" );
        legend(["Enc 0","Enc 1"],'Location','northwest');
    subplot(2,1,2); 
        hold on;
        plot(data(1,:),data(4,:));
        plot(data(1,:),data(5,:));
        ylabel("V");
        xlabel("time (s)");
        hold off
        title('Motor Inputs');
        legend(["M 0","M 1"],'Location','northwest');

else 
    isProper = false;
end