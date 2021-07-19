% Giải hệ phương trình vi phân sử dụng xấp xỉ Newton 
clc;
% main for calculating
endtime = 10; % simulation time
step = 0.01;  % step time
ts = 1;       % time start
td = 0.05;    % pulse width

F_total = zeros(endtime/step+1,1);
[f, A, k, epsilon, psi, u, v, start_func] = init_params(endtime, step, ts, td);
velo = 5;     % velocity

u(1,1) = 0;
v(1,1) = 0;

for t=2:1:(endtime/step+1)
    for i=1:1:16
        [F_u, F_v] = cal_F(A(t,i), u(t-1,i), v(t-1,i), k(t), f(t));
        % calculate new state
        new_u = F_u * step + u(t-1,i);
        if (i==1)
			new_v = (F_v + cal_P_head(u(t-1,1), v(t-1,1), epsilon(t), psi(t)) + start_func(t)) * step + v(t-1,i);
        else
            if (i==16)
                new_v = (F_v + cal_P_tail(u(t-1,15), v(t-1,15), epsilon(t), psi(t))) * step + v(t-1,i);
            else
			new_v = (F_v + cal_P_body(u(t-1,i-1), v(t-1,i-1), u(t-1,i+1), v(t-1,i+1), epsilon(t), psi(t))) * step + v(t-1,i);
            end
        end
        u(t,i) = new_u;
        v(t,i) = new_v;
    end
    % tính tổng lực F
    F_total(t) = force_t(k, f, velo, t, u(t,1:15), u(t,2:16), v(t,1:15), v(t,2:16), A(t,:));
end
