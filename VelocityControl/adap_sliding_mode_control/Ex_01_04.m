%Sliding mode control
%Chapter 01
%Tien 2016.01.24
%Example 1.4.3

close all
clear all

%M=1;    %the controller with a switch function
M=2;    %the controller with a saturation function

%Sampling time
tmax=10;
dt=0.001;
n=round(tmax/dt);

%Reference data
w=1;
t(1)=0;
for i=1:n
   if i>1 t(i)=(i-1)*dt; end;
   thd(i)=0.1*sin(w*t(i));
   dthd(i)=0.1*w*cos(w*t(i));
   d2thd(i)=-0.1*w^2*sin(w*t(i));
end

%System parameters
mc=1.0; m=0.1;  L=0.5;  g=9.81;

%Controller parameters
c=1.5;  xite=0.2;

%Initial values
th(1)=pi/60;
dth(1)=0;
err(1)=thd(1)-th(1);
derr(1)=0;
u(1)=0;
X1i_1=th(1);
X2i_1=dth(1);

for i=2:n
   %System dynamics
   T=L*(4/3-m*cos(X1i_1)^2/(mc+m));
   fXi_1=(g*sin(X1i_1)-m*L*X2i_1^2*cos(X1i_1)*sin(X1i_1)/(mc+m))/T;
   gXi_1=(cos(X1i_1)/(mc+m))/T;
   X1i=X2i_1*dt+X1i_1;
   X2i=(fXi_1+gXi_1*u(i-1))*dt+X2i_1;
   th(i)=X1i;
   dth(i)=X2i;
   X1i_1=X1i;
   X2i_1=X2i;
   
   %Tracking error
   err(i)=thd(i)-th(i);
   derr(i)=(err(i)-err(i-1))/dt;
   
   %Controller
   s(i)=c*err(i)+derr(i);
   if M==1
       u(i)=(1/gXi_1)*(-fXi_1+d2thd(i)+c*derr(i)+xite*sign(s(i)));
   end;
   if M==2
       delta=0.05;
       if s(i)>delta sats=1;
       elseif abs(s(i))<=delta sats=s(i)/delta;
       else sats=-1;
       end;
       u(i)=(1/gXi_1)*(-fXi_1+d2thd(i)+c*derr(i)+xite*sats);
   end;
end;
derr(1)=derr(2);    %for eliminating the differential error at the initial

plot(t,(thd-th)*180/pi);                xlabel('Time (s)');	ylabel('Tracking Error (degree)');
figure;plot(t,th*180/pi,t,thd*180/pi);	xlabel('Time (s)');	ylabel('x,xd (degree)');
axis([0,10,-8,8])
figure;plot(t,u);                       xlabel('Time (s)');	ylabel('Control input');
figure;plot(err,derr);                  xlabel('e');        ylabel('de');
axis([-0.06,0.01,-0.02,0.12])