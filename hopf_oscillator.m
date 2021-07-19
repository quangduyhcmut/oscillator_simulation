clear; clc; close('all');

v0 = .5;
u0 = .5;
t0 = 0;
omega = 2*pi;
amp = 1;
k = 1;

deltaT = 0.001;
tN = 5; % t0 + deltaT*n, with n the number of steps
[t, u, v] = oscillator(t0, u0, v0, deltaT, tN, omega, amp,k);
figure
plot(t, u, 'b');
hold('on');
plot(t, v, 'r');
hold('off');
legend('u', 'v');
figure
plot(u,v);

function [t, u, v] = oscillator(t0, u0, v0, deltaT, tN, omega, amp,k)

    t = (t0:deltaT:tN)';
    u = zeros(size(t));
    v = zeros(size(t));
    u(1) = u0;
    v(1) = v0;
    for i = 1:1:length(t) - 1
% %  basic hopf oscillator   
        if (i>=1200)
            omega=4*pi;
        end
        if (i>3000)
            amp = 2;
        end
        u(i + 1) = (k*(amp^2 - (u(i)^2 + v(i)^2))*u(i) + omega*v(i))*deltaT + u(i);
        v(i + 1) = (k*(amp^2 - (u(i)^2 + v(i)^2))*v(i) - omega*u(i))*deltaT + v(i);
    end
end