% Read data from Excel
filename = 'twinT.xlsx'; % Replace with your file name
sheet = 1; % Adjust sheet number if necessary
data = xlsread(filename, sheet);

% Extract data columns
Hfreq = data(1, :); % Frequency for T(s) (Hz)
Hmag = data(2, :);  % Magnitude for T(s) (dB)
Hphase = data(3, :); % Phase for T(s) (degrees)
% Uncomment the following lines if you have H(s) data
Tfreq = Hfreq;%data(:, 4); % Frequency for H(s) (Hz)
Tmag = data(4, :);  % Magnitude for H(s) (dB)
Tphase = data(5, :); % Phase for H(s) (degrees)

% Set plot limits
Tfreq_min = min(Tfreq);
Tfreq_max = max(Tfreq);
mag_low = min(Tmag) - 10; % Extend lower bound for better visibility
mag_high = max(Tmag) + 10; % Extend upper bound for better visibility
phase_low = -180; % Lower limit for phase plot
phase_high = 180; % Upper limit for phase plot
phase_ticks = -180:45:180; % Phase ticks for y-axis

% Create Bode Plot
fig1 = figure(Name = "Bode Plot");
subplot(2, 1, 1)
    hold on;
    plot([60, 60], [mag_low, mag_high], 'LineWidth', 3, 'Color', 'r');
    plot(Tfreq, Tmag, 'LineWidth', 2, 'Color', 'b');
    % Uncomment to plot H(s) magnitude
    plot(Hfreq, Hmag, 'LineWidth', 2, 'Color', 'g');
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    ylabel("Magnitude (dB)", 'Interpreter', 'latex');
    axis([Tfreq_min, Tfreq_max, mag_low, mag_high]);
    lgd = legend(["","$T(s)$", "$H(s)$"], 'Interpreter', 'latex');
    % title("Bode Plot");
subplot(2, 1, 2)
    hold on;
    plot([60, 60], [phase_low, phase_high], 'LineWidth', 3, 'Color', 'r');
    plot(Tfreq, Tphase, 'LineWidth', 2, 'Color', 'b');
    % Uncomment to plot H(s) phase
    plot(Hfreq, Hphase, 'LineWidth', 2, 'Color', 'g');
    hold off;
    grid on;
    set(gca, 'XScale', 'log');
    xlabel("$f$ (Hz)", 'Interpreter', 'latex');
    ylabel("Phase (degree)", 'Interpreter', 'latex');
    yticks(phase_ticks);
    axis([Tfreq_min, Tfreq_max, phase_low, phase_high]);
    lgd = legend(["","$T(s)$", "$H(s)$"], 'Interpreter', 'latex');
set(fig1, "position", [300, 150, 600, 450]);

