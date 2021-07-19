% initialize parameters
% khởi tạo các tham số ảnh hưởng đến chuyển động của vây
% bao gồm biên độ, tần số, initialization pulse (step)
% biên độ: A(n,16) - mảng 2 chiều, 1 chiều tương ứng 16 tia vây, 1 chiều
% thể hiện thay đổi theo thời gian
% tần số: f(n,16) - mảng 2 chiều
% hệ số hội tụ: k(n,16) - mảng 2 chiều 
% độ lệch phi: psi(n,1) - có thể cài đặt thay đổi theo thời gian
% ts: time start - thời gian khởi tạo xung kích thích dao động
% td: độ rộng xung kích thích dao động

function [f, A, k, epsilon, psi, u, v, start_func] = init_params(endtime, step, ts, td)

    n = endtime/step+1;
    f = zeros(n,1);
    A = zeros(n,16);
    u = zeros(n,16);
    v = zeros(n,16);
    k = zeros(n,1);
    epsilon = zeros(n,1);
    psi = zeros(n,1);
    start_func = zeros(n,1);
    time_start = ts/step+1;
    pulse_width = td/step;
    
    for t=1:1:n
        f(t) = 2;
        A(t,:) = [0.4,.5,.6,.7,.8,.9,1,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,.9];
        k(t) = 5;
        epsilon(t) = 0.8;
        psi(t) = -5*pi/180;
        if ((t>=time_start)&&(t<=time_start+pulse_width))
            start_func(t) =1;
        end
    end
    
end