function PSO_Case
clear all
clc
[g_best,ConvergenceCurves]=pso;
[Fit,PL,QL,VD,V,VSI,Pl,Ql]=Load_Flow(g_best); % Load Flow 
V_base=load('VOLT_BASE.m');
P_base=load('P_BASE.m');
Q_base=load('Q_BASE.m');
%% Results
disp('                            ')
disp('%%%%%%%%%%%%%%%%%%% PSO with capacitor sizing & placement Results %%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('------------------------------------------------------')
disp(['Capacitor Size (Mvar):                 ' num2str(round(g_best(1)/1000,4))]);
disp(['Capacitor Location (Bus):              ' num2str(round(g_best(2),0))]);
disp(['Fitness Value (PU):                    ' num2str(round(Fit,4))]);
disp('------------------------------------------------------')
disp('                            ')
disp('%%%%%%%%%%%%%%%%%%% PSO System Results %%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('------------------------------------------------------')
disp(['Power-Loss (KW):                       ' num2str(round(PL,2))]);
disp(['Reactive Power-Loss (Kvar):              ' num2str(round(QL,2))]);
disp(['Voltage Deviation:                     ' num2str(round(VD,2))]);
disp(['Voltage Stabiliy Index:                ' num2str(round(VSI,2))]);
disp('------------------------------------------------------')
% figure (1);
% plot(V_base,LineWidth=1.5)
% hold on
% plot(V,'c',LineWidth=1.5)
% title('Voltage Profile')
% xlabel('Bus');
% ylabel('Voltage');
% legend('PSO Case','Base Case')
% grid on;
% hold off
% figure (3);
% plot(ConvergenceCurves,LineWidth=1.5)
% title('Convergence curves')
% xlabel('Iteration');
% ylabel('Best Value');
% grid on;
% figure (6);
% bar(P_base,LineWidth=1.5)
% hold on
% 
% %bar(Pl*100000,LineWidth=1.5)
% bar(1:length(Pl*100000),Pl*100000,'c');
% %set(gca,'XTick',1:1:no)
% title('Active Power Loss PSO')
% xlabel('Bus');
% ylabel('Power (Kw)');
% grid on;
% legend('Base Case','PSO Case')
% figure (7);
% bar(Q_base,LineWidth=1.5)
% hold on
% %bar(Ql*100000,LineWidth=1.5)
% bar(1:length(Ql*100000),Ql*100000,'c');
% %set(gca,'XTick',1:1:no)
% title('Reactive Power Loss PSO')
% xlabel('Bus');
% ylabel('Power (Kvar)');
% grid on;
% legend('Base Case','PSO Case')
figure (1);
plot(V,'c',LineWidth=1.5)
hold on
plot(V_base,'b',LineWidth=1.5)
title('Voltage Profile')
xlabel('Bus');
ylabel('Voltage');
legend('PSO Case','Base Case')
grid on;
hold off
figure (2);
plot(ConvergenceCurves,LineWidth=1.5)
title('Convergence curves')
xlabel('Iteration');
ylabel('Best Value');
grid on;
figure (8);
bar(P_base,LineWidth=1.5)
hold on

bar(Pl*100000,LineWidth=1.5)
title('ACTIVE Power Loss')
xlabel('Bus');
ylabel('Active Power (Kw)');
grid on;
legend('Base Case','PSO Case')
figure (9);
bar(Q_base,LineWidth=1.5)

hold on
bar(Ql*100000,LineWidth=1.5)
title('REACTIVE Power Loss')
xlabel('Bus');
ylabel('Reactive Power (Kvar)');
grid on;
legend('Base Case','PSO Case')
end