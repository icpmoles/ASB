function plot_pose(t_a1,t_a2,t_p1,t_p2)
L = 0.127; %m

x_A1 = 0;
y_A1 = 0;

x_P1 = L * cos(t_a1);
y_P1 = L * sin(t_a1);

x_E = x_P1 + L * cos(t_p1) ;
y_E = y_P1 + L * sin(t_p1) ;

x_A2 = 2*L;
y_A2 = 0;

x_P2 = x_A2 + L * cos(t_a2);
y_P2 = L * sin(t_a2);

x_E2 = x_P2 + L * cos(t_p2) ;
y_E2 = y_P2 + L * sin(t_p2) ;

J = vel_jacobian(t_a1,t_a2,t_p1,t_p2);
scal = max([ norm(J(:,1)) , norm(J(:,2))]);
J = 0.1*J/scal;

figure;
hold on;
grid on;
axis equal;
xlim([min([0,x_E,x_P1])   , max([0.3,x_E,x_P2]) ]);
ylim([-0.2, 0.25]);
xlabel('X Position (m)');
ylabel('Y Position (m)');
title("POSE");


% Draw links
plot([x_A1, x_P1], [y_A1, y_P1], 'r-', 'LineWidth', 2); % Actuated link 1
plot([x_A2, x_P2], [y_A2, y_P2], 'b-', 'LineWidth', 2); % Actuated link 2
plot([x_P1, x_E], [y_P1, y_E], 'g-', 'LineWidth', 2); % Passive link 1
plot([x_P2, x_E], [y_P2, y_E], 'g-', 'LineWidth', 2); % Passive link 2
plot([x_P2, x_E2], [y_P2, y_E2], 'g-', 'LineWidth', 2); % Passive link 2 backwards
% plot([x_P1, x_P2], [y_P1, y_P2], 'm-', 'LineWidth', 2); % Cross-link between passive joints

% Draw joints
plot(x_A1, y_A1, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Actuated joint 1
plot(x_A2, y_A2, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); % Actuated joint 2
plot(x_P1, y_P1, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g'); % Passive joint 1
plot(x_P2, y_P2, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g'); % Passive joint 2
plot(x_E, y_E, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % End-effector



% M =  10*vel_jacobian(t_a1,t_a2,t_p1,t_p2);
% q1 = M(:,1)'*[1;1];
% q2 = M(:,2)'*[1;1];
% q = (M' * M)\M'*[1;1];
% q1 = q(1);
% q2 = q(2);


% Draw Vector Field
% plot([x_E, x_E+J(1,1)], [y_E, y_E+J(2,1)], "red", 'LineWidth', 2); % Passive link 1

quiver(x_E,y_E,J(1,1),J(2,1),"red"	);
quiver(x_E,y_E,J(1,2),J(2,2), "blue");



% quiver(x_E,y_E,q1*J(1,1),q1*J(2,1),"black"	);
% quiver(x_E,y_E,q2*J(1,2),q2*J(2,2), "black");
% quiver(x_E,y_E,q1*J(1,1)+q2*J(1,2),q1*J(2,1)+q2*J(2,2),"yellow"	);

% quiver(x_E,y_E,q1,q2, "black");

% plot([x_E, x_E+J(1,2)], [y_E, y_E+J(2,2)], "blue", 'LineWidth', 2); % Passive link 2


hold off;


end


