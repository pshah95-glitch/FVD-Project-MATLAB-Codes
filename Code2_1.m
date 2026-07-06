clc
clear
close all

ms = 240;
mus = 32;
Ks = 17000;
Ktr = 136000;

M = [ms,0;0,mus];
K = [Ks,-Ks;-Ks,Ks+Ktr];

[EigenVectors,EigenValues] = eig(K,M);
omega_n_rad = sqrt(diag(EigenValues));
freq_n_Hz = omega_n_rad/(2*pi);

fprintf('Undamped Natural Frequencies:\n');
fprintf('Sprung Mass mode(suspension) Frequency: %.2f Hz\n',min(freq_n_Hz));
fprintf('Unsprung Mass mode (Wheel Hop) Frequency: %.2f Hz\n',max(freq_n_Hz));
%Parsa Shahrstani/40226059/Project2/Code2_1