clc
clear
close all

ms = 240; 
mus = 32;
Ks = 17000;
Ktr = 136000;
Csh = 600;
Ct = 500;

V_ms = 48/3.6;
lambda = 9.15;
Z0 = 0.05;

f_exc = V_ms/lambda;
w_exc = 2*pi*f_exc;

%Tarif matrix haye M , C , K
M = [ms,0;0,mus];
C = [Csh,-Csh;-Csh,Csh+Ct];
K = [Ks,-Ks;-Ks,Ks+Ktr];

%niroo road
F_road = [0;Ktr+1i*w_exc*Ct]*Z0;

% Dynamic Stiffness Matrix
DynStiff = -w_exc^2*M+1i*w_exc*C+K;

%Z = [Z_s;Z_us]
Z = DynStiff\F_road;
amp_zs = abs(Z(1));
amp_zus = abs(Z(2));

fprintf('Response to Sinewave Road:\n');
fprintf('Excitation Frequency: %.2f Hz \n',w_exc);
fprintf('Amplitude of Sprung Mass (Body): %.1f cm\n',amp_zs*100);
fprintf('Amplitude of Unsprung Mass (Wheel): %.1f cm\n',amp_zus*100);
%Parsa Shahrstani/40226059/Project2/Code3_1