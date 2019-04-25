[a f] = encode_audio("/home/qzpv/docs/rit/spring2019/ml/paper/data/data_speech_commands/cat/00970ce1_nohash_0.wav", 4000, 4);


plot(f, a);
title("Frequency Spectrum of the spoken word 'cat'");
xlabel("Frequency (Hz)");
ylabel("Normalized Amplitude [0, 1]");

function [y f] = fft_freq(x, fs)
    L = length(x);
    f = fs*(0:(L/2))/L;
    
    Y = fft(x);
    y = abs(Y(1:L/2+1));
    y = (y - min(y)) ./ (max(y) - min(y));
end

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

% top x frequencies
% function [a f] = encode_audio(path, band)
%     [y fs] = audioread(path);
%     
%     [tmp ftmp] = fft_freq(y, fs);
%     
%     % make sure they are column vectors
%     if(size(tmp, 1) == 1)
%         tmp = tmp';
%     end
%     
%     if(size(ftmp, 1) == 1)
%         ftmp = ftmp';
%     end
%     
%     tmp = [tmp ftmp];
%     
%     [~, idx] = sort(tmp(:, 1), 'descend');
%     
%     if(band < length(idx))
%         idx = idx(1:band);
%     end
%     
%     tmp = tmp(idx, :);
%     [~, idx] = sort(tmp(:, 2));
%     
%     a = tmp(idx, 1);
%     f = tmp(idx, 2);
%     
% end