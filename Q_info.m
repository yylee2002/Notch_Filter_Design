function [Q, fcenter, fmin, fmax, BW] = Q_info(mag, freq)
    mag_max = max(mag);
    [~, index_center] = min(mag);
    fcenter = freq(index_center);

    thershold = mag_max - 3;
    band = find(mag <= thershold);  % find the 3-dB band
    % display(band);
    index_min = band(1);
    % fmin = freq(index_min);
    fmin_1 = freq(index_min);
    fmin_2 = freq(index_min - 1);
    magmin_1 = mag(index_min);
    magmin_2 = mag(index_min - 1);
    fmin = fmin_1 + (fmin_2 - fmin_1) * (thershold - magmin_1) / (magmin_2 - magmin_1);


    index_max = band(end);
    % fmax = freq(index_max);
    fmax_1 = freq(index_max);
    fmax_2 = freq(index_max - 1);
    magmax_1 = mag(index_max);
    magmax_2 = mag(index_max - 1);
    fmax = fmax_1 + (fmax_2 - fmax_1) * (thershold - magmax_1) / (magmax_2 - magmax_1);


    BW = fmax - fmin;
    Q = fcenter / BW;
end

