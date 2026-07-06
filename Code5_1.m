clc
clear
close all

ms = 240;
mus = 32;
Ksh = 17000;
Ktr = 136000;
Ct = 500;
Csh_old = 600;
Csh_opt = 1010;

f = 0.2:0.05:30;
omega = 2*pi*f;

FR_acc_old = zeros(size(f));  
FR_acc_new = zeros(size(f));  
FR_andaze_old = zeros(size(f));
FR_andaze_new = zeros(size(f));
FR_tire_old = zeros(size(f));
FR_tire_new = zeros(size(f));

M = [ms,0;0,mus];

for i = 1:length(f)
    w = omega(i);
    K = [Ksh,-Ksh;-Ksh,Ksh+Ktr];
    
    %Old
    C_old = [Csh_old,-Csh_old;-Csh_old,Csh_old+Ct];
    F_old = [0;Ktr+1i*w*Ct];
    H_old = (-w^2*M+1i*w*C_old+K)\F_old;
    FR_acc_old(i) = abs(-w^2*H_old(1));
    FR_andaze_old(i) = abs(H_old(1)-H_old(2));
    FR_tire_old(i) = abs(H_old(2)-1);
    
    %New(Optimal)
    C_new = [Csh_opt,-Csh_opt;-Csh_opt,Csh_opt+Ct];
    F_new = [0;Ktr+1i*w*Ct];
    H_new = (-w^2*M+1i*w*C_new+K)\F_new;
    FR_acc_new(i) = abs(-w^2*H_new(1));
    FR_andaze_new(i) = abs(H_new(1)-H_new(2));
    FR_tire_new(i) = abs(H_new(2)-1);
end

figure
subplot(3,1,1)
loglog(f,FR_acc_old,'b--',f,FR_acc_new,'r-','LineWidth',1.5);
title('Sprung Mass Acceleration Frequency Response')
ylabel('Acc (m/s^2 / m)')
legend('Original (C_{sh}=600)','Optimal (C_{sh}=1010)') 
grid on

subplot(3,1,2)
loglog(f,FR_andaze_old,'b--', f,FR_andaze_new,'r-','LineWidth',1.5);
title("Suspension's workspace Frequency Response")
ylabel('Workspace (m/m)')
grid on

subplot(3,1,3)
loglog(f,FR_tire_old,'b--',f,FR_andaze_new,'r-','LineWidth',1.5);
title('Tire Deflection Frequency Response')
xlabel('Frequency (Hz)')
ylabel('Deflection (m/m)')
grid on
%Parsa Shahrstani/40226059/Project2/Code5_1