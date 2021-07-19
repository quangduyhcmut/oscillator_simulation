%Sliding mode control
%Chapter 01
%Tien 2016.01.24
%Example 1.4.3

close all
clear all

%M=1;    %the controller with a switch function
M=2;    %the controller with a saturation function

%Sampling time
tmax=6;
dt=0.001;
n=round(tmax/dt);

%Reference data
wr=1; Ar=1; t(1)=0;
for i=1:n
   if i>1 t(i)=(i-1)*dt; end;
   r(i)=Ar*sin(wr*t(i));
   dr(i)=wr*Ar*cos(wr*t(i));
   d2r(i)=-wr^2*Ar*sin(wr*t(i));
end

%Disturbance
wd=1; Ad=3; d(1)=0;
for i=1:n
   if i>1 t(i)=(i-1)*dt; end;
   d(i)=Ad*sin(wd*t(i));
   dd(i)=wd*Ad*cos(wd*t(i));
   d2d(i)=-wd^2*Ad*sin(wd*t(i));
end
dU=max(d);

%Controller parameters
c=5; xite=3.1;

%Initial values
x(1)=0;
dx(1)=0;
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
   if M==1
       u(i)=(1/b)*(25*dx(i)+d2r(i)+c*derr(i)+(dU+xite)*sign(s(i)));
   elseif M==2
       delta=0.05;
       if s(i)>delta sats=1;
       elseif abs(s(i))<=delta sats=s(i)/delta;
       else sats=-1;
       end;
       u(i)=(1/b)*(25*dx(i)+d2r(i)+c*derr(i)+(dU+xite)*sats);
   end;
end;
derr(1)=derr(2);    %for eliminating the differential error at the initial

plot(t,(r-x)*180/pi);                xlabel('Time (s)');	ylabel('Tracking Error (degree)');
axis([0,6,-0.5,3.5])
figure;plot(t,x*180/pi,t,r*180/pi);	xlabel('Time (s)');	ylabel('x,xd (degree)');
axis([0,6,-70,70])
figure;plot(t,u);                       xlabel('Time (s)');	ylabel('Control input');
axis([0,6,-0.3,0.3])
figure;plot(err,derr);                  xlabel('e');	ylabel('de');
axis([-0.01,0.06,-0.4,1.2])