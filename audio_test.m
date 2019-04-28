% [a f] = encode_audio("./data/data_speech_commands/cat/00970ce1_nohash_0.wav", 4000, 4);


% plot(f, a);
% title("Frequency Spectrum of the spoken word 'cat'");
% xlabel("Frequency (Hz)");
% ylabel("Normalized Amplitude [0, 1]");

[img] = img_audio("./data/data_speech_commands/cat/00970ce1_nohash_0.wav", 4000, 4, 100);

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