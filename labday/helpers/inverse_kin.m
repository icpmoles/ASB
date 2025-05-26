function [t_a1,t_a2,t_p1,t_p2, error] = inverse_kin(x,y, debug)
    L = 0.127; %m
    margin =  0.004;
    beta1 = atan2(y,x);
    beta2 = atan2(y,x-2*L);
    d1 = sqrt(x^2 + y^2);
    d2 = sqrt( (x-2*L)^2 + y^2);
   
    
    if (d1<2*L) && (d2<2*L) && (d1>margin) && (d2>margin)
        error = 0;
        alpha1 = acos(d1/(2*L));
        alpha2 = acos(d2/(2*L));
        t_a1 = beta1 - alpha1;
        t_a2 = to_pos( beta2 - alpha2);
        t_p1 = atan2(y-L*sin(t_a1),x-L*cos(t_a1));
        t_p2 = atan2(y-L*sin(t_a2),x-2*L-L*cos(t_a2));
        
        dp1p2 = L * sqrt( (2-cos(t_a1)+cos(t_a2))^2 + (sin(t_a2)-sin(t_a1))^2);
        
        if ( abs(dp1p2)<margin ) || (abs(t_a1-t_p1)<pi/18) || (abs(t_a2-t_p2)<pi/18)
             error = 1;
              t_a1 = NaN  ;
        t_a2 = NaN  ;
        t_p1 = NaN  ;
        t_p2 = NaN  ;
        end
        
    else
        error = 1;
        t_a1 = NaN  ;
        t_a2 = NaN  ;
        t_p1 = NaN  ;
        t_p2 = NaN  ;
    end
    if debug
        disp("D1% : " + d1/(2*L))
        disp("D2% : " + d2/(2*L))
        disp("BETA_1 : " + rad2deg(beta1))
        disp("BETA_2 : " + rad2deg(beta2))
        disp("ALPHA_1 : " + rad2deg(alpha1))
        disp("ALPHA_2 : " + rad2deg(alpha2))
        disp("t_a1 : " + rad2deg(t_a1))
        disp("t_a2 : " + rad2deg(t_a2))
        disp("t_p1 : " + rad2deg(t_p1))
        disp("t_p2 : " + rad2deg(t_p2))
        disp("sin(p1 - p2) : " + sin(t_p1 - t_p2))
    end
end


function angle = to_pos(d)
    if d<0
        angle = 2*pi + d;
    else
        angle = d;
    end
end
