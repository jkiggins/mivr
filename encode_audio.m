function [a f] = encode_audio(path, band, dec)
    [y fs] = audioread(path);
    
    [a f] = fft_freq(y, fs);
    
    % make sure they are column vectors
    if(size(a, 1) == 1)
        a = a';
    end
    
    if(size(f, 1) == 1)
        f = f';
    end
    
    tmp = [a f];
    
    idx = tmp(:, 2) <= band;
    
    tmp = tmp(idx, :);
    tmp = tmp(1:dec:size(tmp, 1), :);
    
    a = tmp(:, 1);
    f = tmp(:, 2);
end