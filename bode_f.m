function [mag, phase, freq] = bode_f(sys, f_low, f_high)
    [mag_temp, phase_temp, omega] = bode(sys, {2*pi*f_low, 2*pi*f_high});
    mag = 20 .* log(squeeze(mag_temp));
    % phase_max = ceil(max(phase_temp)/360);
    % phase = squeeze(phase_temp) - phase_max;
    phase = mod(squeeze(phase_temp), 360) - 360;
    phase = squeeze(phase_temp);
    freq = omega ./ (2*pi);
end

