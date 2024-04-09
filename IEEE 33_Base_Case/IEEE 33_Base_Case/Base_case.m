function Base_case
clear all
clc
[PL,QL,VD,V,VSI]=Load_Flow; % Load Flow 

%% Results
disp('                            ')
disp('%%%%%%%%%%%%%%%%%%%Base Case Results %%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('------------------------------------------------------')
disp(['Power-Loss (KW):                       ' num2str(round(PL,2))]);
disp(['Reactive Power-Loss (KW):              ' num2str(round(QL,2))]);
disp(['Voltage Deviation:                     ' num2str(round(VD,2))]);
disp(['Voltage Stabiliy Index:                ' num2str(round(VSI,2))]);
disp('------------------------------------------------------')
figure (1);
plot(V,LineWidth=1.5)
title('Voltage Profile')
xlabel('Bus');
ylabel('Voltage');
grid on;
end