function [img] = img_audio(path, band, dec, tsplit)
    img = zeros((band / dec), tsplit); 
    [y fs] = audioread(path);
    
    chunk_size = length(y) / tsplit;
    
    % Split audio into tsplit increments
    for i = 0:(tsplit - 1)
        start = (i * chunk_size + 1);
        nEnd = start + chunk_size - 1;
        [a f] = fft_freq(y(start:nEnd), fs);
        
        % Filtering and stuff
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
        
        img(:, i) = a;
    end
    
    img = reshape(img, numel(img), 1);
end