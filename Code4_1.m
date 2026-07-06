clc
clear
close all

ms = 240;
mus = 32;
Ks = 17000;
Ktr = 136000;
Ct = 500;

%Critical damping baraye sprung mass
Cc = 2*sqrt(Ks*ms);

%damping ratio(zeta) az 0.1 ta 0.5
zeta_range = linspace(0.1,0.5,50);
Csh_range = zeta_range*Cc;

rms_acc = zeros(size(Csh_range));
rms_tire = zeros(size(Csh_range));

% States ==> x = [zs-zus,zs_dot,zus-zr,zus_dot]^T
for i = 1:length(Csh_range)
    Csh = Csh_range(i);
    
    A = [0,1,0,-1;
         -Ks/ms,-Csh/ms,0,Csh/ms;
          0,0,0,1;
          Ks/mus,Csh/mus,-Ktr/mus,-(Csh+Ct)/mus];
    
    B = [0;0;-1;Ct/mus]; %Input ==> road velocity
    
    C_mat = [0,0,1,0;%Outputs ==> y = [zus-zr(Tire Deflection);acc_s(Sprung Mass Accel)]
            -Ks/ms,-Csh/ms,0,Csh/ms];
    D = [0;0];
    
    sys = ss(A,B,C_mat,D);
    
    %mohasebe  matrix covariance ba farz inke vooroodi white noise normal shodamoon 1 bashad
    [cov_y,~] = covar(sys,1); 
    
    %RMS = square root variance (eleman haye ghotri)
    rms_tire(i) = sqrt(cov_y(1,1));
    rms_acc(i) = sqrt(cov_y(2,2));
end

figure
plot(rms_tire,rms_acc,'b-','LineWidth',2);
hold on
grid on

%Optimal Damping
zeta_opt = 0.25;
Csh_opt = zeta_opt*Cc;
rms_tire_opt = interp1(zeta_range,rms_tire,zeta_opt);
rms_acc_opt = interp1(zeta_range,rms_acc,zeta_opt);

plot(rms_tire_opt,rms_acc_opt,'ro','MarkerSize',8,'MarkerFaceColor','r');
text(rms_tire_opt,rms_acc_opt,sprintf('  Optimal Design'),'VerticalAlignment','bottom');

xlabel('RMS Tire Deflection (m) - Road Holding');
ylabel('RMS Sprung Mass Acceleration (m/s^2) - Comfort');
title('Trade-off Diagram: Comfort vs Road Holding');
%Parsa Shahrstani/40226059/Project2/Code4_1
