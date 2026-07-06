clc
clear
close all

ms = 240;
mus = 32;
Ksh = 17000;
Ktr = 136000;
Ct = 500;
Csh = 1010;
f = 0.2:0.05:30; 
omega = 2*pi*f;
N = length(f);

acc_base = zeros(1,N); 
acc_mod1 = zeros(1,N); 
acc_mod2 = zeros(1,N); 
acc_mod3 = zeros(1,N); 
acc_mod4 = zeros(1,N); 
tire_base = zeros(1,N);
tire_mod1 = zeros(1,N);
tire_mod2 = zeros(1,N);
tire_mod3 = zeros(1,N);
tire_mod4 = zeros(1,N);

for i = 1:N
    w = omega(i);
    
    M_base = [ms,0;0,mus];
    C_base = [Csh,-Csh;-Csh,Csh+Ct];
    K_base = [Ksh,-Ksh;-Ksh,Ksh+Ktr];
    F_base = [0;Ktr+1i*w*Ct];%niroo jade
    
    A_base = -w^2*M_base+1i*w*C_base+K_base;
    Z_base = A_base\F_base;
    acc_base(i) = abs(-w^2*Z_base(1));
    tire_base(i) = abs(Z_base(2)-1);
    

    %1 ==> Unsprung Mass = 70%
    M1 = [ms,0;0,0.7*mus];
    A1 = -w^2*M1+1i*w*C_base+K_base;
    Z1 = A1\F_base;
    acc_mod1(i) = abs(-w^2*Z1(1)); 
    tire_mod1(i) = abs(Z1(2)-1);
    
    %2 ==> Tire Stiffness = 50%
    K2 = [Ksh,-Ksh;-Ksh,Ksh+0.5*Ktr];
    F2 = [0;0.5*Ktr+1i*w*Ct];
    A2 = -w^2*M_base+1i*w*C_base+K2;
    Z2 = A2\F2;
    acc_mod2(i) = abs(-w^2*Z2(1)); 
    tire_mod2(i) = abs(Z2(2)-1);
    
    %3==> Damping = 50%
    C3 = [0.5*Csh,-0.5*Csh;-0.5*Csh,0.5*Csh+Ct];
    A3 = -w^2*M_base+1i*w*C3+K_base;
    Z3 = A3\F_base;
    acc_mod3(i) = abs(-w^2*Z3(1)); 
    tire_mod3(i) = abs(Z3(2)-1);
    
    %4==> Sprung Mass = 400 kg
    M4 = [400,0;0,mus];
    A4 = -w^2*M4+1i*w*C_base+K_base;
    Z4 = A4\F_base;
    acc_mod4(i) = abs(-w^2*Z4(1)); 
    tire_mod4(i) = abs(Z4(2)-1);
end

%Barasi Road Holding
figure
subplot(1,2,1)
loglog(f,tire_base,'k-',f,tire_mod1,'b--','LineWidth',1.5)
title('Case 1: 70% Unsprung Mass')
xlabel('Frequency (Hz)')
ylabel('Tire Deflection (m/m)')
legend('Baseline','Modified')
grid on

subplot(1,2,2)
loglog(f,tire_base,'k-',f,tire_mod2,'r--','LineWidth',1.5)
title('Case 2: 50% Tire Stiffness')
xlabel('Frequency (Hz)')
ylabel('Tire Deflection (m/m)')
legend('Baseline','Modified')
grid on

%Barasi Comfort
figure
subplot(1,2,1)
loglog(f,acc_base,'k-',f,acc_mod3,'m--','LineWidth',1.5)
title('Case 3: 50% Shock Damping')
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2 / m)')
legend('Baseline', 'Modified')
grid on

subplot(1,2,2)
loglog(f,acc_base,'k-',f,acc_mod4,'g--','LineWidth',1.5)
title('Case 4: Sprung Mass = 400 kg')
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2 / m)')
legend('Baseline','Modified')
grid on
%Parsa Shahrstani/40226059/Project2/Code6_1234