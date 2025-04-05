function [isProper] = smartPlotEncVoltage(data,filename,filter)
% rows:
% 1 = timestamps
% 2 = encoder 0
% 3 = encoder 1
% 4 = motor Volt 0
% 5 = motor Volt 1
data
Ts = 0.002;
CheckTime = 0.75;
CheckIndex = int32(CheckTime/Ts);
t = data(1,:); % get timeline

if size(data,1)>3 %more than three lines
   if size(data,2)>CheckIndex

        isProper = true;
        if size(data,1)<=6 
            angleFactor = pi/2048;
        else
            angleFactor = 1;
        end

        if abs(data(4,CheckIndex)) > abs(data(5,CheckIndex))
            motorId = 0;
        else 
            motorId = 1;
        end
        
        motorV = data(4+motorId,CheckIndex);
        
    
        if filter || size(data,1)<=6 
            gridRows = 3;
        else
            gridRows = 2;
        end
        f = figure;
        subplot(gridRows,1,1);
            hold on;
            plot(t ,data(2,:)*angleFactor);
            plot(t ,data(3,:)*angleFactor);
            ylabel("rad");
            xlabel("time (s)");
            hold off
            sgtitle(filename,'Interpreter','none');
            title('Encoders');
            subtitle("Motor"+motorId+" at: " + motorV + "V" );
            legend(["Enc 0","Enc 1"],'Location','northwest');
        subplot(gridRows,1,2); 
            hold on;
            plot(t ,data(4,:));
            plot(t ,data(5,:));
            ylabel("V");
            xlabel("time (s)");
            hold off
            title('Motor Inputs');
            legend(["M 0","M 1"],'Location','northwest');
    
         if filter
            f.Position(3:4) = [500 700];
            e = data(2+motorId,:)*angleFactor; % get "excitated" motor
            pole1 = 2*pi*50;
            pole2 = 2*pi*50;
            derivAndLowPass = zpk([0],[-pole1 -pole2],(pole1 * pole2));
            subplot(gridRows,1,3); 
                hold on;
                ls = lsimplot(derivAndLowPass,e,t);
                % ls.ylim([-5 5]);
                ls.title("Estimated ang. speed");
                ls.ylabel("omega_L (rad/s)");
                hold off;
         end

         if filter
            f.Position(3:4) = [500 700];
            e = data(2+motorId,:)*angleFactor; % get "excitated" motor
            pole1 = 2*pi*50;
            pole2 = 2*pi*50;
            derivAndLowPass = zpk([0],[-pole1 -pole2],(pole1 * pole2));
            subplot(gridRows,1,3); 
                hold on;
                ls = lsimplot(derivAndLowPass,e,t);
                % ls.ylim([-5 5]);
                ls.title("Estimated ang. speed");
                ls.ylabel("omega_L (rad/s)");
                hold off;
         end

         if size(data,1)<=6  
            subplot(gridRows,1,3); 
            plot(t ,data(6,:));
            title("frequency voltage (rad/s)")
         end
    

    else
     subplot(2,1,1);
                hold on;
                plot(t ,data(2,:)/(2048/pi));
                plot(t ,data(3,:)/(2048/pi));
                ylabel("rad");
                xlabel("time (s)");
                hold off
                sgtitle(filename,'Interpreter','none');
                title('Encoders');
                legend(["Enc 0","Enc 1"],'Location','northwest');
      subplot(2,1,2); 
                hold on;
                plot(t ,data(4,:));
                plot(t ,data(5,:));
                ylabel("V");
                xlabel("time (s)");
                hold off
                title('Motor Inputs');
                legend(["M 0","M 1"],'Location','northwest');
    end
    
else 

    % subplot(2,1,1);
            hold on;
            plot(t ,data(2,:)/(2048/pi));
            plot(t ,data(3,:)/(2048/pi));
            ylabel("rad");
            xlabel("time (s)");
            hold off
            sgtitle(filename,'Interpreter','none');
            title('Encoders');
            legend(["Enc 0","Enc 1"],'Location','northwest');
        % subplot(2,1,2); 
        %     hold on;
        %     plot(t ,data(4,:));
        %     plot(t ,data(5,:));
        %     ylabel("V");
        %     xlabel("time (s)");
        %     hold off
        %     title('Motor Inputs');
        %     legend(["M 0","M 1"],'Location','northwest');
    
    isProper = false;

end
hold off
end