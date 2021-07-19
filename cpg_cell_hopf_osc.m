clear; clc; close('all');
% reference: https://journals.sagepub.com/doi/10.1177/1729881417723440
y0 = 0.001;
x0 = 0;
t0 = 0;
omega0 = 2*pi; %feqxency
amp = 10; % amplitxde
K = 2; %coupling constant

deltaT = 0.001; %time step
ts = 0.1/deltaT; %time step to start
td = 0.01/deltaT; %time width 

number_of_cells = 4;
t_delay = 2*pi/(omega0 * number_of_cells);

tN = 5; % t0 + deltaT*n, with n the nxmber of steps
lambda = 0.1;
[t, x1, y1, x2, y2, x3, y3, x4, y4] = oscillator(t0, x0, y0, deltaT, tN, omega0, amp, K, ts, td, t_delay, lambda);

subplot(3,1,1);
plot(t, x1, 'b');
grid('on');
hold('on');
plot(t, x2, 'g');
plot(t, x3, 'r');
plot(t, x4, 'm');
legend('head','body1','body2','tail');

subplot(3,1,2);
plot(t, x4, 'm');
grid('on');

% for i = 1:numel(t)
%     subplot(3,1,1);
%     plot (t(1:i),x1(1:i),'b');
%     xlim([0 tN]);
%     ylim([-amp amp]);
%     drawnow
% end


% arcsin(magnitude) => theta

% subplot(3,1,3);
% t_ = (t0:deltaT:tN)';
% I = zeros(size(t_));
% for t = 1:1:length(t_) - 1
%     if ((t>ts) && (t<ts+td))
%             I(t) = 1;
%     else
%             I(t) = 0;
%     end
% end
% plot(t_, I)

% figure
% plot(x1, y1, 'b');
% grid('on');

function [t_, x1, y1, x2, y2, x3, y3, x4, y4] = oscillator(t0, x0, y0, deltaT, tN, omega0, amp, K, ts, td, t_delay, lambda)

    t_ = (t0:deltaT:tN)';
    
    x1 = zeros(size(t_));
    y1 = zeros(size(t_));
    omega1 = zeros(size(t_));
    
    x2 = zeros(size(t_));
    y2 = zeros(size(t_));
    omega2 = zeros(size(t_));
    
    x3 = zeros(size(t_));
    y3 = zeros(size(t_));
    omega3 = zeros(size(t_));
    
    x4 = zeros(size(t_));
    y4 = zeros(size(t_));
    omega4 = zeros(size(t_));
    
    I = zeros(size(t_));
    I(1) = 1;
    x1(1) = x0;
    y1(1) = y0;
    omega1(1) = omega0;
    
    x2(1) = 0;
    y2(1) = 0;
    omega2(1) = omega0;
    
    x3(1) = 0;
    y3(1) = 0;
    omega3(1) = omega0;
    
    x4(1) = 0;
    y4(1) = 0;
    omega4(1) = omega0;
    
    for t = 1:1:length(t_) - 1
        % %  adaptive hopf oscillator with start-xp signal I(t)   
        % start-xp signal I(t): step(t-ts) - step(t-ts-td)
        if ((ts<t) && (t<td))
            I(t) = 1;
        else
            I(t) = 0;
        end
        % delay signal
        if (abs((t-ts)*deltaT - (t_delay)) <= deltaT)
            diract = 1;
        else
            diract = 0;
        end
        
        % head cell 1
        x1(t + 1) = ((amp^2 - (x1(t)^2 + y1(t)^2))*x1(t) + omega1(t)*y1(t) + K*I(t))*deltaT + x1(t);
        y1(t + 1) = ((amp^2 - (x1(t)^2 + y1(t)^2))*y1(t) - omega1(t)*x1(t))*deltaT + y1(t);
        omega1(t+1) = omega1(t);
%         omega1(t + 1) = (K*I(t) * y1(t) / sqrt(x1(t)^2 + y1(t)^2))*deltaT + omega1(t);
        % end head cell 1
        % body cell 2
        x2(t + 1) = ((amp^2 - (x2(t)^2 + y2(t)^2))*x2(t) + omega2(t)*y2(t)+ diract*(x1(t)-x2(t)) + lambda*(y1(t)*sin(pi/4)-x1(t)*cos(pi/4)))*deltaT + x2(t);
        y2(t + 1) = ((amp^2 - (x2(t)^2 + y2(t)^2))*y2(t) - omega2(t)*x2(t)+ diract*(y1(t)-y2(t)) )*deltaT + y2(t);
        omega2(t+1) = omega2(t);
%         omega2(t + 1) = (K*I(t) * y2(t) / sqrt(x2(t)^2 + y2(t)^2))*deltaT + omega2(t);
        % end body cell 2
        % body cell 3
        x3(t + 1) = ((amp^2 - (x3(t)^2 + y3(t)^2))*x3(t) + omega3(t)*y3(t)+ diract*(x2(t)-x3(t)) + lambda*(y2(t)*sin(pi/4)-x2(t)*cos(pi/4)))*deltaT + x3(t);
        y3(t + 1) = ((amp^2 - (x3(t)^2 + y3(t)^2))*y3(t) - omega3(t)*x3(t)+ diract*(y2(t)-y3(t)) )*deltaT + y3(t);
        omega3(t+1) = omega3(t);
        % end body cell 3 
        % tail cell 4
        x4(t + 1) = ((amp^2 - (x4(t)^2 + y4(t)^2))*x4(t) + omega4(t)*y4(t)+ diract*(x3(t)-x4(t)) + lambda*(y3(t)*sin(pi/4)-x3(t)*cos(pi/4)))*deltaT + x4(t);
        y4(t + 1) = ((amp^2 - (x4(t)^2 + y4(t)^2))*y4(t) - omega4(t)*x4(t)+ diract*(y3(t)-y4(t)) )*deltaT + y4(t);
        omega4(t+1) = omega4(t);
        % end tail cell 4
       
    end
end