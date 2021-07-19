clear all
clc

%Sampling time
tmax=30;
dt=0.01;
n=round(tmax/dt);

%Reference data
for i = 1:n
%     if (i<n/2)
%         v(i)=0.05;%+0.05*cos(2*pi*i/150);
%         ref(i)=v(i)*(i-1)*dt;
%     else
        v(i)=0.1;%+0.05*cos(2*pi*i/150);
        ref(i)=v(i)*(i-1)*dt;
%     end
%     ref(i)=0.05*i/150+0.05/2/pi*sin(2*pi*i/150);
end
m = 0.7;

%Distubance
for i = 1:n
    d(i)=(-0.01+0.02*rand)/m;
end
dL=-0.01/m;
dU=0.01/m;
d1 = (dU-dL)/2;
d2 = (dU+dL)/2;

    
%Controller parameters
c1 = 50;
c2 = 0.1;
eta = 0.02;
fa=0.006754;
fb=0.00823;

%Initial values
th(1)=0;
dth(1)=0;
f(1)=0;
t(1)=0;
Ly(1) = 0;
dLy(1)=0;
err(1)=-ref(1)+th(1);
derr(1) = -v(1)+dth(1);
dref(1) = 0;
d2ref(1) = 0;
u(1) = 0;
Xi_1=[th(1); dth(1)];

th_e(1)=0;
dth_e(1)=0;
err_e(1)=-ref(1)+th_e(1);
derr_e(1) = -v(1)+dth_e(1);
temp(1)=0;
Yi_1=[th_e(1); dth_e(1)];

%System
b=1/m;
A=[0 1; 0 0];
B=[0; b];
C=[0;1];

for i=2:n
   t(i)=(i-1)*dt;
   %Estimated system
   %System dynamics
   Xi=(A*Xi_1+B*u(i-1)-C*(0.256/m.*dth(i-1)^2-d(i-1)))*dt+Xi_1;
   th(i)=Xi(1);
   dth(i)=Xi(2);
   Xi_1=Xi;
   %Tracking error
   err(i)=-ref(i)+th(i);
   derr(i)=(err(i)-err(i-1))/dt;
   %Controller
   dref(i) = (ref(i)-ref(i-1))/dt;
   d2ref(i)= (dref(i)-dref(i-1))/dt;
   s(i)=dth(  i)+c1*err(i)-dref(i);
   u(i)=(1/b)*(0.256/m*dth(i)^2+0.01-0.02*rand-c2*s(i)-err(i)-c1*derr(i)+d2ref(i)-eta*sign(s(i)));
   Ly(i)=1/2*s(i)^2+1/2*err(i)^2;
   dLy(i)= Ly(i)-Ly(i-1);
   if (u(i)>0.67)
       u(i) = 0.67;
   end
   if (u(i)<0)
       u(i) = 0;
   end
   
   
%    Real system
%    System dynamics
   Yi=(A*Yi_1+C*(force_t(f(i-1),dth_e(i-1),t(i))/m-0.256/m*dth_e(i-1)^2-0.01+0.02*rand))*dt+Yi_1;
   th_e(i)=Yi(1);
   dth_e(i)=Yi(2);
   Yi_1=Yi;
   %Tracking error
   err_e(i)=-ref(i)+th_e(i);
   derr_e(i)=(err_e(i)-err_e(i-1))/dt;
   %Controller
   dref(i) = (ref(i)-ref(i-1))/dt;
   d2ref(i)= (dref(i)-dref(i-1))/dt;
   s_e(i)=dth_e(i)+c1*err_e(i)-dref(i);
   temp(i)=(1/b)*(0.256/m*dth_e(i)^2+0.01-0.02*rand-c2*s_e(i)-err_e(i)-c1*derr_e(i)+d2ref(i)-eta*sign(s_e(i)));
   if (temp(i)>0.67)
       temp(i) = 0.67;
   end
   if (temp(i)<0)
       temp(i) = 0;
   end
   f(i) = sign(temp(i))*((-fb+sqrt(fb^2+4*fa*abs(temp(i))))/2/fa);
end

figure(1)
plot(t,dth);
hold on
plot(t,v,'r')
grid on
legend('Dap ung van toc','Van toc mong muon'); 
ylabel('Van toc (m/s)');
xlabel('Thoi gian (s)');

% axis([0,0.01,-10,10])

figure(2)
plot(t,dth_e)
hold on
plot(t,v,'r')
grid on
legend('Dap ung van toc','Van toc mong muon');  
xlabel('Van toc (m/s)');
ylabel('Thoi gian (s)');

figure(3)
plot(t,temp,'r',t,u,'b');

figure(4)
plot(err,derr);

