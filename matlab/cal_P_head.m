function P_head = cal_P_head(post_u, post_v, epsilon, psi)
    P_head = epsilon * (post_v*cos(psi) - post_u*sin(psi));
end