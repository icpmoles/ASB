function smartPlot(data)
% rows:
% 1 = timestamps
% 2 = encoder 0
% 3 = encoder 1
% 4 = motor Volt 0
% 5 = motor Volt 1
figure
subplot(2,1,1);
    hold on;
    plot(data(1,:),data(2,:));
    plot(data(1,:),data(3,:));
    hold off
    title('Encoders')
    legend(["Enc 0","Enc 1"],'Location','northwest')
subplot(2,1,2); 
    hold on;
    plot(data(1,:),data(4,:));
    plot(data(1,:),data(5,:));
    hold off
    title('Motor Inputs')
    legend(["Volt 0","Volt 1"],'Location','northwest')
end

