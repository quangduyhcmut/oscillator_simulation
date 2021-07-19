function P_tail = cal_P_tail(pre_u, pre_v, epsilon, psi)
    P_tail = epsilon * (pre_u*sin(psi) + pre_v*cos(psi));
end