N=16;
figure
subplot(2,N,[1,N])
plot(out.tout, out.u1);
hold on
plot(out.tout, out.u2);
plot(out.tout, out.u3);
plot(out.tout, out.u4);
plot(out.tout, out.u5);
plot(out.tout, out.u6);
plot(out.tout, out.u7);
plot(out.tout, out.u8);
plot(out.tout, out.u9);
plot(out.tout, out.u10);
plot(out.tout, out.u11);
plot(out.tout, out.u12);
plot(out.tout, out.u13);
hold off
alpha(0.2);
% legend('CPG1', 'CPG2','CPG3','CPG4','CPG5','CPG6','CPG7');
grid on

for i = 1:N
       
    step = (numel(out.tout)-1)/(N-1);
    time = (i-1)*step+1;
    time_ = (time - 1)/(numel(out.tout)-1)*t_total;
    
    pose = [out.u1(time)*180/pi, out.u2(time)*180/pi, ...
        out.u3(time)*180/pi, out.u4(time)*180/pi, ...
        out.u5(time)*180/pi, out.u6(time)*180/pi, ...
        out.u7(time)*180/pi, out.u8(time)*180/pi, ...
        out.u9(time)*180/pi, out.u10(time)*180/pi, ...
        out.u11(time)*180/pi, out.u12(time)*180/pi, ...
        out.u13(time)*180/pi];
    
    index = linspace(1,13,13);
    
    subplot(2,N,N+i); 
    plot(pose, index,'-ro','MarkerIndices',index)
    
    hold on
    plot([0 1; 0 14], '--b');

    xlim([-45 45]);
    ylim([1 14]);
    title(num2str(time_,3));
end
