%Sliding mode control
%Chapter 01
%Tien 2016.01.24
%Example 1.6.3

close all
clear all

%Sampling time
tmax=3;
dt=0.001;
n=round(tmax/dt);

%Reference data
wr=2*pi; Ar=1; t(1)=0;
for i=1:n
   if i>1 t(i)=(i-1)*dt; end;
   r(i)=Ar*sin(wr*t(i));
   dr(i)=wr*Ar*cos(wr*t(i));
   d2r(i)=-wr^2*Ar*sin(wr*t(i));
end

%Disturbance
wd=1; Ad=50; d(1)=0;
for i=1:n
   if i>1 t(i)=(i-1)*dt; end;
   d(i)=Ad*sin(wd*t(i));
   dd(i)=wd*Ad*cos(wd*t(i));
   d2d(i)=-wd^2*Ad*sin(wd*t(i));
end
dU=max(d);

%Controller parameters
c=25;
xite=0.1;

%Initial values
x(1)=-0.15;
dx(1)=-0.15;
err(1)=r(1)-x(1);
derr(1)=0;
u(1)=0;
Xi_1=[x(1); dx(1)];

%System
b=133;
A=[0 1; 0 -25];
B=[0; b];
C=[0;1];

for i=2:n
   %System dynamics
   Xi=((A*Xi_1+B*u(i-1))+C*d(i-1))*dt+Xi_1;
   x(i)=Xi(1);
   dx(i)=Xi(2);
   Xi_1=Xi;
   
   %Tracking error
   err(i)=r(i)-x(i);
   derr(i)=(err(i)-err(i-1))/dt;
   
   %Controller
   s(i)=c*err(i)+derr(i);
   ueq(i)=(c*derr(i)+d2r(i)+25*dx(i))/b;
   usw(i)=(dU+xite)*sign(s(i))/b;
   u(i)=ueq(i)+usw(i);
end;
derr(1)=derr(2);    %for eliminating the differential error at the initial

plot(t,(x-r)*180/pi);               xlabel('Time (s)');	ylabel('Tracking Error (degree)');
figure;plot(t,x*180/pi,t,r*180/pi);	xlabel('Time (s)');	ylabel('x,xd (degree)');
axis([0,3,-80,80])
figure;plot(t,u);               	xlabel('Time (s)');	ylabel('Control input');
axis([0,3,-1.8,1.8])
figure;plot(err,derr);              xlabel('e');        ylabel('de');
axis([-0.05,0.35,-3.0,7.5])