function [lambda_v] = vel_jacobian(t_a1,t_a2,t_p1,t_p2)
    L = 0.127; %m
    % g1 = sin(t_a1-t_p2)/sin(t_p1-t_p2);
    % g2 = sin(t_p2-t_a2)/sin(t_p1-t_p2);
    % lambda_v = L*[ -sin(t_a1 )-sin(t_p1)*g1    +sin(t_p1)*g2 ;
    %     cos(t_a1 )+cos(t_p1)*g1    -cos(t_p1)*g2 ];
    det = sin(t_p2 - t_p1);
    g11 = sin(t_a1-t_p2)/det;
    % g12 = sin(p2-a2)/det;
    % g21 = sin(a1-p1)/det;
    g22 = sin(t_a2-t_p1)/det; % check why minus
    lambda_v = L * [ 
        -sin(t_a1 )-sin(t_p1)*g11 , -sin(t_a2)-sin(t_p2)*g22;
        cos(t_a1)+cos(t_p1)*g11, cos(t_a2)-cos(t_p2)*g22;
    ];

    
end


