% Hàm force_t tính tổng lực F
% k: mảng k (n,1)
% freq: mảng f(n,16)
% velo: vận tốc
% time: thời gian cần tính F
% q1, q2: output u CPG(1->15) và CPG(2->16)
% p1 ,p2: output v CPG(1->15) và CPG(2->16)
% A
function Fxs = force_t(k, freq, velo, time, q1, q2, p1 ,p2, A)
    global v0 ro Cn D L N hmax denta_q c1 c2 s1 s2 q1_d q2_d s

    hmax = 0.1; % chiều dài tia vây
    v0 = velo;  % vận tốc 
    f = freq;   % tần số
    t = time;   % thời điểm 
    ro = 1000;  % khoi luong rieng cua nuoc
    Cn = 2.8;
    N = 16;     % số tia vây
    L = 0.195;  % chiều dài  bộ vây
    D = L/(N-1);% khoảng cách giữa 2 vây     
    Fx = zeros(N);

    Fxs = 0;
    
    s1 = sin(q1);
    s2 = sin(q2);
    c1 = cos(q1);
    c2 = cos(q2);
    denta_q = q2 - q1;
    
    for s = 1:1:N-1
        % đạo hàm của ui
        q1_d = k(t)*(A(s)-q1(s)^2-p1(s)^2)*q1(s) - 2*pi*f(t)*p1(s) + 0;
        % đạo hàm của ui+1
        q2_d = k(t)*(A(s)-q2(s)^2-p2(s)^2)*q2(s) - 2*pi*f(t)*p2(s) + 0;
        % Tính tích phân lực f tại tia vây thứ s
        Fx(s) = quad2d(@lucfx,0,1,0,hmax); 
    end
    
    for s = 1:1:N
        Fxs = Fxs + Fx(s);
    end
end

function fn = lucfx(w_b, h)
    global D ro Cn c1 c2 s1 s2 q1_d q2_d denta_q v0 s
    delta = sqrt(2.*D.^2.*w_b.*(w_b-1).*(1 -cos(denta_q(s))) + h.^2.*(sin(denta_q(s))).^2 + D.^2);
    en_1 = D.*(h./D.*sin(denta_q(s)));
    vn = D.*h./delta.*(-h./D.*v0.*sin(denta_q(s))+(c1(s).*(1 - w_b) + w_b.*c2(s)).*(c1(s).*q1_d + (c2(s).*q2_d - c1(s).*q1_d).*w_b) + (s1(s).*(w_b -1) - w_b.*s2(s)).*(-s1(s).*q1_d +(s1(s).*q1_d - s2(s).*q2_d).*w_b));
    fn  = -1./2.*ro.*Cn.*en_1.*(vn.^2).*sign(vn);
    
end