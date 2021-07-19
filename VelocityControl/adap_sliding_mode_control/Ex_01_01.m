%Sliding mode control
%Chapter 01
%Tien 2016.01.24

close all
clear all

%Sampling time
tmax=15;
dt=0.01;
n=round(tmax/dt);

%Reference data
Ar=1; wr=1; t(1)=0;
for i=1:n
   if i>1 t(i)=(i-1)*dt; end;
   thd(i)=Ar*sin(wr*t(i));
   dthd(i)=wr*Ar*cos(wr*t(i));
   d2thd(i)=-wr^2*Ar*sin(wr*t(i));
end

%Controller parameters
c=0.7;
xite=0.5;
J=10;       %kg.m2

%Initial values
th(1)=0.5;
dth(1)=1;
err(1)=th(1)-thd(1);
derr(1)=dth(1)-dthd(1);
u(1)=0;
V(1)=0;
dV(1)=0;
Xi_1=[th(1); dth(1)];

%System
A=[0 1; 0 0];
B=[0; 1/J];

for i=2:n
   %System dynamics
   Xi=((A*Xi_1+B*u(i-1)))*dt+Xi_1;
   th(i)=Xi(1);
   dth(i)=Xi(2);
   Xi_1=Xi;
   
   %Tracking error
   err(i)=th(i)-thd(i);
   derr(i)=(err(i)-err(i-1))/dt;
   
   %Controller
   s(i)=c*err(i)+derr(i);
   u(i)=J*(-c*err(i-1)+d2thd(i-1)-xite*sign(s(i-1)));
   V(i)=1/2*s(i)^2+1/2*err(i)^2;
   dV(i)=V(i)-V(i-1);
end;

plot(t,(th-thd)*180/pi);                xlabel('Time (s)');	ylabel('Tracking Error (degree)');
figure;plot(t,th*180/pi,t,thd*180/pi);	xlabel('Time (s)');	ylabel('x,xd (degree)');
axis([0,15,-80,80]);
figure;plot(t,u);                       xlabel('Time (s)');	ylabel('Control input');
axis([0,15,-20,20]);
figure;plot(err,derr);                  xlabel('e');        ylabel('de');
axis([-0.10,0.60,-0.30,0.10]);
figure; plot(t,dV);