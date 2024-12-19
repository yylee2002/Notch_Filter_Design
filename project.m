%% Final Project
%% Active Twin-T Notch Filter Design
close all; clear; clc;

%% Parameters
% Notch Filter (Open-loop)
R = 270e3;    % (F)
C = 10e-9;    % (Ω)
C1 = C;       %10e-9;   % (F)
C2 = C;       %10e-9;   % (F)
C3 = 2*C;     %20e-9;   % (F)
R1 = R;       %270e3;   % (Ω)
R2 = R;       %270e3;   % (Ω)
R3 = R/2;     %136e3;   % (Ω)

% Feedback
R4 = 40e3;    % (Ω)
R5 = 82;      % (Ω)
beta = R5 / (R4 + R5);
beta = 1;

%% Simulation Settings
% Range of Bode Plot
f_low = 1e0;   % (Hz)
f_high = 1e4;  % (Hz)
mag_low = -150;% (dB)
mag_high = 0;  % (dB)

%% Transfer function
s = tf('s');
Zc = 1 / (s*C1 + s*C2 + 1/R3);
Zr = 1 / (1/R1 + 1/R2 + s*C3);

sysT = (s^2*C1*C2*Zc + Zr/R1/R2) / (s*C2 + 1/R2 - s^2*C2^2*Zc - Zr/R2/R2);
[Tmag, Tphase, Tfreq] = bode_f(sysT, f_low, f_high);
[Tmag_max, Tfreq_max, Tindex_max] = get_info(Tmag, Tfreq, "max");
[Tmag_min, Tfreq_min, Tindex_min] = get_info(Tmag, Tfreq, "min");

sysH = sysT / (1 + sysT*beta);
[Hmag, Hphase, Hfreq] = bode_f(sysH, f_low, f_high);
[Hmag_max, Hfreq_max, Hindex_max] = get_info(Hmag, Hfreq, "max");
[Hmag_min, Hfreq_min, Hindex_min] = get_info(Hmag, Hfreq, "min");


%% Simulation Results
fig1 = figure(Name = "Bode Plot");
subplot(2, 1, 1)
    hold on;
    plot([Tfreq_min, Tfreq_min], [mag_low, mag_high], 'LineWidth', 3, 'Color', 'r');
    plot(Tfreq, Tmag, 'LineWidth', 2, 'Color', 'b');
    plot(Hfreq, Hmag, 'LineWidth', 2, 'Color', 'g');
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    ylabel("$|T|$ (dB)", 'Interpreter', 'latex');
    axis([-inf, inf, mag_low, mag_high]);
subplot(2, 1, 2)
    hold on;
    plot([Tfreq_min, Tfreq_min], [-360, 360], 'LineWidth', 3, 'Color', 'r');
    plot(Tfreq, Tphase, 'LineWidth', 2, 'Color', 'b');
    plot(Hfreq, Hphase, 'LineWidth', 2, 'Color', 'g');
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    xlabel("$f$ (Hz)", 'Interpreter', 'latex');
    ylabel("$\angle T$ (degree)", 'Interpreter', 'latex');% title("");
    yticks([-360, -270, -180, -90, 0, 90]);
    axis([-inf, inf, -360, 0]);
set(fig1, "position", [400, 150, 800, 450]);
figname = "Results/Bode_T";
saveas(fig1, figname);
saveas(fig1, figname + ".png");

% figure;
% hold on;
% bode(sysT);
% bode(sysH);
% margin(sysH);

%% 
figure;
sysTest = 1 / ((1+s*R*C)^2/(1+(s*R*C)^2)*2-1);
bode(sysTest);
