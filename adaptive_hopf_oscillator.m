clear; clc; close('all');

y0 = 0.001;
x0 = 0;
t0 = 0;
omega0 = 4*pi; %feqxency
amp = 2; % amplitxde
K = 2; %coxpling constant

deltaT = 0.001; %time step
ts = 0.1/deltaT; %time step to start
td = 0.01/deltaT; %time width 

tN = 5; % t0 + deltaT*n, with n the nxmber of steps
[t, x, y] = oscillator(t0, x0, y0, deltaT, tN, omega0, amp, K, ts, td);

% legend('x', 'y');

subplot(2,1,1);
plot(t, x, 'b');
grid('on');

subplot(2,1,2);
t_ = (t0:deltaT:tN)';
I = zeros(size(t_));
for t = 1:1:length(t_) - 1
    if ((t>ts) && (t<ts+td))
            I(t) = 1;
    else
            I(t) = 0;
    end
end
plot(t_, I)

figure
plot(x, y, 'b');
grid('on');

function [t_, x, y] = oscillator(t0, x0, y0, deltaT, tN, omega0, amp, K, ts, td)

    t_ = (t0:deltaT:tN)';
    x = zeros(size(t_));
    y = zeros(size(t_));
    omega = zeros(size(t_));
    I = zeros(size(t_));
    I(1) = 1;
    x(1) = x0;
    y(1) = y0;
    omega(1) = omega0;
    for t = 1:1:length(t_) - 1
% %  adaptive hopf oscillator with start-xp signal I(t)   
% start-xp signal I(t): step(t-ts) - step(t-ts-td)
        if ((ts<t) && (t<td))
            I(t) = 1;
        else
            I(t) = 0;
        end
        x(t + 1) = ((amp^2 - (x(t)^2 + y(t)^2))*x(t) + omega(t)*y(t) + K*I(t))*deltaT + x(t);
        y(t + 1) = ((amp^2 - (x(t)^2 + y(t)^2))*y(t) - omega(t)*x(t))*deltaT + y(t);
        omega(t + 1) = (K*I(t) * y(t) / sqrt(x(t)^2 + y(t)^2))*deltaT + omega(t);
    end
end