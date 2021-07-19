function estimatefunction()
F=[];
fre = [];
vel = [];
for t=1:1:500
    for i = 1:1:100
        f=force_t(t/50,i/500,0);
        F = [F;f];
        fre=[fre;t/50];
        vel=[vel;i/500];
    end
end
p=fit([fre,vel],F,'poly22');
plot(p,[fre,vel],F,'Style','Residuals');
p=fit(fre,F,'poly2')
plot(fre,F);
end