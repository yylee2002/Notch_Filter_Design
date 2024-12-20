function [Q, fcenter, fmin, fmax, BW] = Q_info(mag, freq)
    mag_max = max(mag);
    [~, index_center] = min(mag);
    fcenter = freq(index_center);

    band = find(mag <= mag_max - 3);  % find the 3-dB band
    % display(band);
    index_min = band(1);
    fmin = freq(index_min);
    index_max = band(end);
    fmax = freq(index_max);
    BW = fmax - fmin;

    Q = fcenter / BW;
end

