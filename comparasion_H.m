%% Final Project: Active Twin-T Notch Filter Design and Measurement Comparison (H(s))
close all; clear; clc;

%% Parameters for Transfer Function
R = 265e3;    % (Ω)
C = 10e-9;    % (F)

% Feedback
R4 = 20e3;    
R5 = 80e3;    
beta = R5 / (R4 + R5);

%% Transfer Function (Theoretical)
s = tf('s');
sysH = (1 + (s*R*C)^2) / (1 + 4*(1-beta)*s*R*C + (s*R*C)^2); % Theoretical H(s)

%% Read Measurement Data from Excel
filename = 'twinT.xlsx'; % Replace with your file name
sheet = 1; % Adjust sheet number if necessary
data = xlsread(filename, sheet);

% Extract data columns for H(s)
Hfreq_meas = data(1, :); % Frequency (Hz)
Hmag_meas = data(2, :);  % Magnitude (dB)
Hphase_meas = data(3, :); % Phase (degrees)

%% Evaluate Theoretical Transfer Function at Measured Frequencies
omega_meas = 2 * pi * Hfreq_meas; % Convert frequency to angular frequency
H_theory = freqresp(sysH, omega_meas); % Evaluate transfer function at these frequencies

% Convert results to magnitude (dB) and phase (degrees)
Hmag_theory = 20 * log10(abs(squeeze(H_theory)));
Hphase_theory = angle(squeeze(H_theory)) * (180 / pi); % Convert radians to degrees

%% Set Plot Limits
mag_low = min([min(Hmag_meas), min(Hmag_theory)]) - 10; % Extend lower bound for better visibility
mag_high = max([max(Hmag_meas), max(Hmag_theory)]) + 10; % Extend upper bound for better visibility
phase_low = -180; 
phase_high = 180; 
phase_ticks = -180:45:180;

%% Create Bode Plot (Comparison)
fig1 = figure(Name = "Bode Plot for H(s)");
subplot(2, 1, 1)
    hold on;
    plot(Hfreq_meas, Hmag_theory, 'LineWidth', 2, 'Color', 'g'); % Theoretical
    plot(Hfreq_meas, Hmag_meas, '--','LineWidth', 2, 'Color', '#32CD32'); % Measurement
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    ylabel("Magnitude (dB)", 'Interpreter', 'latex');
    axis([min(Hfreq_meas), max(Hfreq_meas), mag_low, mag_high]);
    lgd = legend(["Theoretical", "Measurement"], 'Interpreter', 'latex');
    %title("Bode Plot (Magnitude) for H(s)", 'Interpreter', 'latex');
subplot(2, 1, 2)
    hold on;   
    plot(Hfreq_meas, Hphase_theory,  'LineWidth', 2, 'Color', 'g'); % Theoretical
    plot(Hfreq_meas, Hphase_meas,'--', 'LineWidth', 2, 'Color', '#32CD32'); % Measurement
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    xlabel("$f$ (Hz)", 'Interpreter', 'latex');
    ylabel("Phase (degrees)", 'Interpreter', 'latex');
    yticks(phase_ticks);
    axis([min(Hfreq_meas), max(Hfreq_meas), phase_low, phase_high]);
    lgd = legend(["Theoretical", "Measurement"], 'Interpreter', 'latex');
    %title("Bode Plot (Phase) for H(s)", 'Interpreter', 'latex');
set(fig1, "position", [300, 150, 600, 450]);
