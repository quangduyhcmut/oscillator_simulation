% calculating fundamental component of oscillators
function [F_u, F_v] = cal_F(A, u, v, k, f)
    F_u = k*(A-u*u-v*v)*u - 2*pi*f*v;
    F_v = k*(A-u*u-v*v)*v + 2*pi*f*u;
end
