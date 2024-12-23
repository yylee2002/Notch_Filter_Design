%% Final Project: Active Twin-T Notch Filter Design and Measurement Comparison
close all; clear; clc;

%% Parameters for Transfer Function
R = 265e3;    % (Ω)
C = 10e-9;    % (F)
C1 = C;       
C2 = C;       
C3 = 2*C;     
R1 = R;       
R2 = R;       
R3 = R/2;     

% Feedback
R4 = 20e3;    
R5 = 80e3;    
beta = R5 / (R4 + R5);

%% Transfer Function (Theoretical)
s = tf('s');
Zc = 1 / (s*C1 + s*C2 + 1/R3);
Zr = 1 / (1/R1 + 1/R2 + s*C3);

sysT = (s^2*C1*C2*Zc + Zr/R1/R2) / (s*C2 + 1/R2 - s^2*C2^2*Zc - Zr/R2/R2);

%% Read Measurement Data from Excel
filename = 'twinT.xlsx'; % Replace with your file name
sheet = 1; % Adjust sheet number if necessary
data = xlsread(filename, sheet);

% Extract data columns for T(s)
Tfreq_meas = data(1, :); % Frequency (Hz)
Tmag_meas = data(4, :);  % Magnitude (dB)
Tphase_meas = data(5, :); % Phase (degrees)

%% Evaluate Theoretical Transfer Function at Measured Frequencies
omega_meas = 2 * pi * Tfreq_meas; % Convert frequency to angular frequency
H_theory = freqresp(sysT, omega_meas); % Evaluate transfer function at these frequencies

% Convert results to magnitude (dB) and phase (degrees)
Tmag_theory = 20 * log10(abs(squeeze(H_theory)));
Tphase_theory = angle(squeeze(H_theory)) * (180 / pi); % Convert radians to degrees

%% Set Plot Limits
mag_low = min([min(Tmag_meas), min(Tmag_theory)]) - 10; % Extend lower bound for better visibility
mag_high = max([max(Tmag_meas), max(Tmag_theory)]) + 10; % Extend upper bound for better visibility
phase_low = -180; 
phase_high = 180; 
phase_ticks = -180:45:180;

%% Create Bode Plot (Comparison)
fig1 = figure(Name = "Bode Plot");
subplot(2, 1, 1)
    hold on;
    plot(Tfreq_meas, Tmag_theory, 'LineWidth', 2, 'Color', 'b'); % Theoretical
    plot(Tfreq_meas, Tmag_meas,  '--','LineWidth', 2, 'Color', 'c'); % Measurement
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    ylabel("Magnitude (dB)", 'Interpreter', 'latex');
    axis([min(Tfreq_meas), max(Tfreq_meas), mag_low, mag_high]);
    lgd = legend(["Theoretical", "Measurement"], 'Interpreter', 'latex');
    %title("Bode Plot (Magnitude)", 'Interpreter', 'latex');
subplot(2, 1, 2)
    hold on;
    plot(Tfreq_meas, Tphase_theory, 'LineWidth', 2, 'Color', 'b'); % Theoretical
    plot(Tfreq_meas, Tphase_meas, '--', 'LineWidth', 2, 'Color', 'c'); % Measurement
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    xlabel("$f$ (Hz)", 'Interpreter', 'latex');
    ylabel("Phase (degrees)", 'Interpreter', 'latex');
    yticks(phase_ticks);
    axis([min(Tfreq_meas), max(Tfreq_meas), phase_low, phase_high]);
    lgd = legend(["Theoretical", "Measurement"], 'Interpreter', 'latex');
    %title("Bode Plot (Phase)", 'Interpreter', 'latex');
set(fig1, "position", [300, 150, 600, 450]);

