% Convolutional Neural Network Approach

close all ; clear all;

%% Load data file by file, training each time
base_path = "/home/qzpv/docs/rit/spring2019/ml/paper/data/data_speech_commands";
words = [
    "bed" "bird" "cat" "dog" "down" "eight" "five" "follow" "forward"...
    "four" "go" "happy" "house" "learn" "left" "marvin" "nine" "no" "off"...
    "on" "one" "right" "seven" "sheila" "six" "stop" "three" "tree" "two"...
    "up" "visual" "wow" "yes" "zero"
];
num_samples = 105829;

net = net_init(5);

x = zeros(1001, num_samples);
targets = zeros(length(words), num_samples);

sample=1

for i = 1:length(words)
    path = sprintf("%s/%s", base_path, words(i));
    files = dir(fullfile(path, '*.wav'));
    
    for j = 1:length(files)
        % read in audio file
        fpath = sprintf("%s/%s", files(i).folder, files(i).name);
        [a f] = encode_audio(fpath, 4000, 4);
        
        try
            x(1:size(a, 1), sample) = a;
        catch ME
            size(a)
            max(f)
            fpath
            sample
            return
        end
        
        % one-hot target value, same for every sample in a given file
        targets(i, sample) = 1;   
        
        sample = sample+1;
    end
end

net = net_train(net, x, targets);

%% Functions
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

function net = net_init(hlayer_size)
    setdemorandstream(2014784333);   %seed for random number generator
    net = patternnet(hlayer_size);
    
    net.divideParam.trainRatio = 0.8;  %note- splits are done in a random fashion
    net.divideParam.valRatio = 0.2;
    net.divideParam.testRatio = 0.0;
end

function net = net_train(net, inputs, targets)
    [net,tr] = train(net, inputs, targets);  %return neural net and a training record
end