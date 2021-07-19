clear all
clc

%Sampling time
tmax=50;
dt=0.01;
n=round(tmax/dt);


%Reference data
for i = 1:n
    if (i<n/5)
        v(i)=0.05;
    end
    if (i>=n/5)&&(i<2*n/5)
        v(i)=0.1;
    end
    if (i>=2*n/5)&&(i<3*n/5)
        v(i)=0.15;
    end
    if (i>=3*n/5)&&(i<4*n/5)
        v(i)=0.2;
    end
        if (i>=4*n/5)
        v(i)=0.25;
    end
    ref(i)=v(i)*(i-1)*dt;
end
m = 0.7;

%Distubance
for i = 1:n
    d(i)=(-0.01+0.02*rand)/m;
    d_e(i) =(-0.01+0.01*rand)/m;
end
dL=-0.01/m;
dU=0.01/m;
d1 = (dU-dL)/2;
d2 = (dU+dL)/2;

dL_e = -0.01;
dU_e = 0;
d1_e = (dU_e -dL_e)/2;
d2_e = (dU_e +dL_e)/2;


%Controller parameters
c=0;
epc=0;
k=10;
fa=0.006754;
fb=0.00823;

%Initial values
th(1)=0;
dth(1)=0;
f(1)=0;
t(1)=0;
err(1)=ref(1)-th(1);
derr(1) = v(1)-dth(1);
u(1) = 0;
Xi_1=[th(1); dth(1)];


th_e(1)=0;
dth_e(1)=0;
err_e(1)=ref(1)-th_e(1);
derr_e(1) = v(1)-dth_e(1);
temp(1)=0;
Yi_1=[th_e(1); dth_e(1)];

%System
b=1/m;
A=[0 1; 0 0];
B=[0; b];
C=[0;1];

for i=2:n
   t(i)=(i-1)*dt;
   %Mô ph?ng x?p x?
   %System dynamics
   Xi=(A*Xi_1+B*u(i-1)-C*(0.256/m.*Xi_1(2)^2-d(i-1)))*dt+Xi_1;
   th(i)=Xi(1);
   dth(i)=Xi(2);
   Xi_1=Xi;
   %Tracking error
   err(i)=ref(i)-th(i);
   derr(i)=(err(i)-err(i-1))/dt;
   %Controller
   s(i)=c*err(i)+derr(i);
   dc=d2-d1*sign(s(i));
   u(i)=(1/b)*(epc*sign(s(i))+k*s(i)-c*derr(i)+0.256/m*dth(i)^2-dc);
   if (u(i)>0.67)
       u(i) = 0.67;
   end
   if (u(i)<-0.67)
       u(i) = -0.67;
   end
   
%    Mô ph?ng h? th?c
%    System dynamics
   Yi=(A*Yi_1+C*(force_t(f(i-1),dth_e(i-1),t(i))/m-0.256/m*dth_e(i-1)^2-0.01+0.01*rand))*dt+Yi_1;
   th_e(i)=Yi(1);
   dth_e(i)=Yi(2);
   Yi_1=Yi;
   %Tracking error
   err_e(i)=ref(i)-th_e(i);
   derr_e(i)=(err_e(i)-err_e(i-1))/dt;
   %Controller
   s_e(i)=c*err_e(i)+derr_e(i);
   dc_e=d2_e-d1_e*sign(s_e(i));
   temp(i)=(1/b)*(epc*sign(s_e(i))+k*s_e(i)-c*derr_e(i)+0.256/m*dth_e(i)^2-dc_e);
   if (temp(i)>0.67)
       temp(i) = 0.67;
   end
   if (temp(i)<-0.67)
       temp(i) = -0.67;
   end
   f(i) = sign(temp(i))*((-fb+sqrt(fb^2+4*fa*abs(temp(i))))/2/fa);
end

figure(1)
plot(t,dth);
hold on
plot(t,v,'-.r')
grid on
legend('Dap ung van toc','Van toc mong muon'); 
ylabel('Van toc (m/s)');
xlabel('Thoi gian (s)');
axis([0,50,0,0.26])

figure(2)
plot(t,dth_e)
hold on
plot(t,v,'-.r')
grid on
legend('Dap ung van toc','Van toc mong muon');  
ylabel('Van toc (m/s)');
xlabel('Thoi gian (s)');
axis([0,50,0,0.26])


figure(4)
plot(err,derr);
grid on;


