close all ; clear all;

%% Load data file by file
base_path = "./data/data_speech_commands";
words = [
    "bed" "bird" "cat" "dog" "down" "eight" "five" "follow" "forward"...
    "four" "go" "happy" "house" "learn" "left" "marvin" "nine" "no" "off"...
    "on" "one" "right" "seven" "sheila" "six" "stop" "three" "tree" "two"...
    "up" "visual" "wow" "yes" "zero"
];
num_samples = 104165;

x = zeros(993, num_samples);
y = zeros(length(words), num_samples);
file_paths = string(zeros(1, num_samples));

sample=1

for i = 1:length(words)
    path = sprintf("%s/%s", base_path, words(i));
    audiofiles = dir(fullfile(path, '*.wav'));
    
    for j = 1:length(audiofiles)
        % read in audio file
        fpath = sprintf("%s/%s", audiofiles(j).folder, audiofiles(j).name);
        
        [sig fs] = audioread(fpath);
        
        Fs = fs;                                             % Sampling Frequency (Change If Different)
        Fn = Fs/2;                                              % Nyquist Frequency
        Wp = [150  5800]/Fn;                                    % Normalised Passband
        Ws = [ 50  6100]/Fn;                                    % Normalised Stopband
        Rp =  1;                                                % Passband Ripple (dB)
        Rs = 30;                                                % Stopband Ripple (dB)
        [n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Chebyshev Type II Order
        [b,a] = cheby2(n,Rs,Ws);                                % IIR Filter Coefficients
        [SOS,G] = tf2sos(b,a);                                  % Convert To Second-Order-Section For Stability
%         figure(1)
%         freqz(SOS, 4096, Fs)                                    % Check Filter Performance
        sig = filtfilt(SOS,G, sig);
        
        sig = abs(spectrogram(sig, 1000));
        rsz_row = floor(size(sig,1)/4) * 4;
        rsz_col = floor(size(sig,2)/4) * 4;
        sig = sig(1:rsz_row, 1:rsz_col);
        sig = sepblockfun(sig,[4,4],'max');
        sig = reshape(sig, numel(sig), 1);
        sig = (sig - min(sig)) ./ (max(sig) - min(sig));
        
       
        try
            x(1:size(a, 1), sample) = a;
            file_paths(1, sample) = fpath;
        catch ME
            size(a)
            max(f)
            fpath
            sample
            return
        end
        
        % one-hot target value, same for every sample in a given file
        y(i, sample) = 1;   
        
        sample = sample+1;
        
        if(mod(sample, 1000) == 0)
            fprintf("at sample %i of %i\n", sample, num_samples);
        end
    end
end

num_samples = sample - 1;

x = x(:, 1:(num_samples));
y = y(:, 1:(num_samples));

save('fftimg_xy', 'x', 'y', 'file_paths', 'words', 'num_samples');