clc;
clear;
close;
%%
n = 16;
w = 4*pi;
k = 20;
r = 15 * 2*pi/360; % radian
deltaT = 2*pi/(n*w);
% deltaT = 0.1;
t_sample = 0.001;
% ts = 0.1;
ts = deltaT;
td = 0.01;
t_total = 15;

%%
sb = 1;
sf = 0;

%%
u0 = 0;
v0 = 0;