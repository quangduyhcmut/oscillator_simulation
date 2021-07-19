% plot limit cycle
figure('Name','Limit cycle','NumberTitle','off');
plot(u,v);
title('Limit cycle of 16 CPG');
xlabel('u');
ylabel('v');
legend('CPG1','CPG2','CPG3','CPG4','CPG5','CPG6','CPG7','CPG8','CPG9','CPG10',...
    'CPG11','CPG12','CPG13','CPG14','CPG15','CPG16');
grid on;

% plot some CPG
num_plot = 5;
figure('Name','CPG output','NumberTitle','off');
xdata = 0:step:endtime;
for i=1:1:num_plot
    plot(xdata,u(:,i));
    hold on;
end
title('CPG output');
xlabel('time');
ylabel('theta');
grid on;

%plot force F
figure('Name','Total Force','NumberTitle','off');
plot(xdata,F_total);
title('Total Force');
xlabel('Time (s)');
ylabel('F (N)');
grid on;
% % animation
% figure('Name','Animation of fin ray','NumberTitle','off');
% for t=1:1:(endtime/step+1)
%     plot(u(i));
%    
% end
