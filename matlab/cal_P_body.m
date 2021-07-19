function P_body = cal_P_body(pre_u, pre_v, post_u, post_v, epsilon, psi)
    P_body = epsilon * (pre_u*sin(psi) + pre_v*cos(psi) - post_u*sin(psi) + post_v*cos(psi));
end