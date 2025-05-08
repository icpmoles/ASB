function [x, y, p1 , p2, error] = direct_kinematics(a1,a2)
% error: 0 = nothing
% 1 = arms too close
% 2 = ellipse
% 4 = access


d_too_close = 0.004;
smallAngle = deg2rad(10);
L = 0.127;

X_1 = L * cos(a1);
Y_1 = L  *sin(a1);

X_2 = 2*L + L * cos(a2);
Y_2 = L  *sin(a2);


dp = sqrt( (X_1 - X_2)^2 + (Y_1 - Y_2)^2);
if dp< 2 * L
    
    dx = (X_2 -X_1)/dp;
    dy = (Y_2 -Y_1)/dp;
    
    
    X_C = (X_1 +  X_2 )/2;
    Y_C = (Y_1 +  Y_2 )/2;
    
    
    h = sqrt( L^2 - (dp/2)^2) ;
    
    X_E = X_C + h * (-dy);
    Y_E = Y_C + h * (dx);
    
    
    % 
    % beta1 = atan2(Y_E,X_E)
    % beta2 = atan2(Y_E,2*L-X_E)
    
    thetap1 = atan2(Y_E-Y_1,X_E-X_1);
    thetap2 = atan2(Y_E-Y_2,X_E-X_2);

    % 
    % X_Eii = X_C - h * (-dy);
    % Y_Eii = Y_C - h * (dx);
    % 
    % beta1ii = atan2(Y_Eii,X_Eii)
    % beta2ii = atan2(Y_Eii,2*L-X_Eii)
    % pii = sign(beta1ii * beta2ii)
    
    err = 0;
    if dp<d_too_close
        err = err + 1;
    end
    
    if sin(thetap1-a1)>sin(smallAngle) && sin(thetap2-a2)>sin(smallAngle)
        % Configuration OK
        [x, y, p1 , p2, error] = deal(X_E, Y_E, thetap1, thetap2, 0);
    elseif abs(sin(thetap1-a1))<sin(smallAngle) || abs(sin(thetap2-a2))<sin(smallAngle)
        % Center singularity
        err = err + 2;
        [x, y, p1 , p2, error] = deal(X_E, Y_E, thetap1, thetap2, err);
    elseif abs(sin(thetap1-thetap2))<sin(smallAngle) 
        % Border singularity
        err = err + 4;
        [x, y, p1 , p2, error] = deal(X_E, Y_E, thetap1, thetap2, err);
    else
        % generic error?
        [x, y, p1 , p2, error] = deal(X_E, Y_E, thetap1, thetap2, 16);
    end

    
    % 
    % if pi>0
    %      thetap1 = atan2(Y_Ei-Y_1,X_Ei-X_1);
    %      thetap2 = atan2(Y_Ei-Y_2,X_Ei-X_2);
    %      err = err + checkBoundaries(a1,a2,thetap1, thetap2);
    % 
    %      [x, y, p1 , p2, error] = deal(X_Ei, Y_Ei, thetap1, thetap2, err);
    % else
    %      thetap1 = atan2(Y_Eii-Y_1,X_Eii-X_1);
    %      thetap2 = atan2(Y_Eii-Y_2,X_Eii-X_2);
    %      err = err + checkBoundaries(a1,a2,thetap1, thetap2);
    %      [x, y, p1 , p2, error] = deal(X_Eii, Y_Eii, thetap1, thetap2, err); 
    % end
else
    % impossible
    [x, y, p1 , p2, error] = deal(NaN, NaN, NaN, NaN, 8);
end
end


% function err = checkBoundaries(a1,a2,p1, p2)
% % 4 == straight arm 
% % 8 == p1 // p2
%     err = 0;
%     if sin(a1-p1)>0 || sin(a2-p2)>0
%         err =  2;
%     % if abs(sin(a1-p1))<0.001 || abs(sin(a2-p2))<0.001  
%     elseif  sin(p1-p2)<0
%          err =  1;
%     end
% 
% 
% end