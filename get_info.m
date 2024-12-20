function [mag_res, freq_res, index] = get_info(mag, freq, type)
    if strcmp(type, "max")
        % Find the maximum magnitude
        [mag_res, index] = max(mag);
        % Get the corresponding frequency
        freq_res = freq(index);
    elseif strcmp(type, "min")
        % Find the minimum magnitude
        [mag_res, index] = min(mag);
        % Get the corresponding frequency
        freq_res = freq(index);
    else
        error('Invalid type. Use "max" or "min", or "Q".');
    end
end

