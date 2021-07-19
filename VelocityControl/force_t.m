function Fxs = force_t(freq, velo , time)
global phi_max f s L N lamda hmin hmax D ro Cn c1 c2 s1 s2 q1 q2 q1_d q2_d denta_q v0

phi_max = pi/12;
hmin = 0;
hmax = 0.1;
L = 0.195;
N = 16;
D = L/(N-1);
f = freq;
t = time;
ro = 1000;
lamda = 0.195;
Cn = 2.8;
s = 0;
v0 = velo;
Fx = [];
Fxs = 0;
for s = 0:1:N-1
    q1 = phi_max*sin(2*pi*f*t - 2*pi*s*L/((N-1)*lamda));
    q2 = phi_max*sin(2*pi*f*t - 2*pi*(s+1)*L/((N-1)*lamda));
    q1_d = 2*pi*f*phi_max*cos(2*pi*f*t - 2*pi*s*L/((N-1)*lamda));
    q2_d = 2*pi*f*phi_max*sin(2*pi*f*t - 2*pi*(s+1)*L/((N-1)*lamda));
    denta_q = q2 - q1;
    s1 = sin(q1); 
    s2 = sin(q2);
    c1 = cos(q1);
    c2 = cos(q2);
    Fx(s+1) = quad2d(@lucfx,0,1,0,hmax);
end
  for s = 0:1:15
      Fxs = Fxs  + Fx(s+1);
  end
end

function fn = lucfx(w_b, h)
global  D  ro Cn c1 c2 s1 s2 q1_d q2_d denta_q v0
delta = sqrt(2.*D.^2.*w_b.*(w_b-1).*(1 -cos(denta_q)) + h.^2.*(sin   (denta_q)).^2 + D.^2);
size(delta)
en_1 = D.*(h./D.*sin(denta_q));
vn = D.*h./delta.*(-h./D.*v0.*sin(denta_q)+(c1.*(1 - w_b) + w_b.*c2).*(c1.*q1_d + (c2.*q2_d - c1.*q1_d).*w_b) + (s1.*(w_b -1) - w_b.*s2).*(-s1.*q1_d +(s1.*q1_d - s2.*q2_d).*w_b));
fn  = -1./2.*ro.*Cn.*en_1.*(vn.^2).*sign(vn);
% disp(w_b)
end

