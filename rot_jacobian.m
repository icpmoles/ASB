function [lambda] = rot_jacobian(t_a1,t_a2,t_p1,t_p2)
  a = sin(t_p1 - t_p2);
  lambda = [ sin(t_a1 - t_p2) sin(t_p2-t_a2);
    sin(t_a1 - t_p1) sin(t_p1-t_a2)] / a ;

end

