clear; clc; close('all');

v0 = 1;
u0 = 0;
t0 = 0;
omega = pi/2;

deltaT = 0.0001;
tN = 50; % t0 + deltaT*n, with n the number of steps
[t, u, v] = oscillator(t0, u0, v0, deltaT, tN, omega);
plot(t, u, 'b');
hold('on');
plot(t, v, 'r');
hold('off');
legend('u', 'v');

function [t, u, v] = oscillator(t0, u0, v0, deltaT, tN, omega)

    t = (t0:deltaT:tN)';
    u = zeros(size(t));
    v = zeros(size(t));
    u(1) = u0;
    v(1) = v0;
    for i = 1:1:length(t) - 1
% %  sin cos oscillator       
        u(i + 1) = omega*deltaT*v(i) + u(i);
        v(i + 1) = - omega*deltaT*u(i) + v(i);
    end
end