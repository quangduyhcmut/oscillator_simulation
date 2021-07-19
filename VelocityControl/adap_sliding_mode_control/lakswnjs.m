%Sliding mode control
%Chapter 01
%Tien 2016.01.24

close all
clear all

%Sampling time
tmax=15;
dt=0.001;
n=round(tmax/dt);

%Reference data
Ar=1; wr=1; t(1)=0;
for i=1:n
   if i>1 t(i)=(i-1)*dt; end;
   d(i)=10*sin(pi*t(i));
   thd(i)=Ar*sin(wr*t(i));
   dthd(i)=wr*Ar*cos(wr*t(i));
   d2thd(i)=-wr^2*Ar*sin(wr*t(i));
end

%Controller parameters
c=15;
epsilon=5;
k=10;
b=133;      

%Initial values
th(1)=-0.15;
dth(1)=-0.15;
err(1)=-th(1)+thd(1);
derr(1)=-dth(1)+dthd(1);
u(1)=0;
Xi_1=[th(1); dth(1)];

%System
A=[0 1; 0 -25];
B=[0; b];
C=[0;-1];

for i=2:n
   %System dynamics
   Xi=((A*Xi_1+B*u(i-1)+C*d(i-1)))*dt+Xi_1;
   th(i)=Xi(1);
   dth(i)=Xi(2);
   Xi_1=Xi;
   
   %Tracking error
   err(i)=-th(i)+thd(i);
   derr(i)=(err(i)-err(i-1))/dt;
   
   %Controller
   s(i)=c*err(i)+derr(i);
   dU=10;
   dL=-10;
   d1= (dU-dL)/2;
   d2=(dU+dL)/2;
   dc=d2-d1*sign(s(i));
   u(i)=1/b*(epsilon*sign(s(i))+k*s(i)+c*(dthd(i)-dth(i))+d2thd(i)+25*dth(i)-dc);
end;

plot(t,(thd-th)*180/pi);                xlabel('Time (s)');	ylabel('Tracking Error (degree)');
figure;plot(t,th*180/pi,t,thd*180/pi);	xlabel('Time (s)');	ylabel('x,xd (degree)');
axis([0,15,-80,80]);
figure;plot(t,u);                       xlabel('Time (s)');	ylabel('Control input');
axis([0,15,-0.3,0.3]);
figure;plot(err,derr);                  xlabel('e');        ylabel('de');
axis([-0.010,0.18,-1.5,1.5]);