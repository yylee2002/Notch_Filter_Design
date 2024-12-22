function [mag, phase, freq] = bode_f(sys, f_low, f_high, f_min)
    if nargin == 3
        [mag_temp, phase_temp, omega] = bode(sys, {2*pi*f_low, 2*pi*f_high});
        mag = 20 .* log10(squeeze(mag_temp));
        % phase_max = ceil(max(phase_temp)/360);
        % phase = squeeze(phase_temp) - phase_max;
        % phase = mod(squeeze(phase_temp), 360) - 360;
        phase = squeeze(phase_temp);
        freq = omega ./ (2*pi);
    elseif nargin == 4
        refine_min = f_min / 5;
        refine_max = f_min * 5;
        if (f_low >= refine_min) && (f_high <= refine_max)
            [mag_temp, phase_temp, omega] = bode(sys, {2*pi*f_low, 2*pi*f_high});
            mag = 20 .* log10(squeeze(mag_temp));
            phase = squeeze(phase_temp);
            freq = omega ./ (2*pi);
        elseif (f_low < refine_min) && (f_high <= refine_max)
            [mag_temp1, phase_temp1, omega1] = bode(sys, {2*pi*f_low, 2*pi*refine_min});
            [mag_temp2, phase_temp2, omega2] = bode(sys, {2*pi*refine_min, 2*pi*f_high});
            mag = 20 .* log10([squeeze(mag_temp1); squeeze(mag_temp2)]);
            phase = [squeeze(phase_temp1); squeeze(phase_temp2)];
            freq = [omega1; omega2] ./ (2*pi);
        elseif (f_low >= refine_min) && (f_high > refine_max)
            [mag_temp1, phase_temp1, omega1] = bode(sys, {2*pi*f_low, 2*pi*refine_max});
            [mag_temp2, phase_temp2, omega2] = bode(sys, {2*pi*refine_max, 2*pi*f_high});
            mag = 20 .* log10([squeeze(mag_temp1); squeeze(mag_temp2)]);
            phase = [squeeze(phase_temp1); squeeze(phase_temp2)];
            freq = [omega1; omega2] ./ (2*pi);
        elseif (f_low < refine_min) && (f_high > refine_max)
            [mag_temp1, phase_temp1, omega1] = bode(sys, {2*pi*f_low, 2*pi*refine_min});
            [mag_temp2, phase_temp2, omega2] = bode(sys, {2*pi*refine_min, 2*pi*refine_max});
            [mag_temp3, phase_temp3, omega3] = bode(sys, {2*pi*refine_max, 2*pi*f_high});
            mag = 20 .* log10([squeeze(mag_temp1); squeeze(mag_temp2); squeeze(mag_temp3)]);
            phase = [squeeze(phase_temp1); squeeze(phase_temp2); squeeze(phase_temp3)];
            freq = [omega1; omega2; omega3] ./ (2*pi);
        end
end

