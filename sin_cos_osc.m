clear;
clc;
close all;

[a] = f(1,2,3);

function [out] = f(x,k,r)
    out = k*(-x/r + 4*atan(x/r)/pi);
end

