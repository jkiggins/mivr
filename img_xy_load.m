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

x = zeros(1001, num_samples);
y = zeros(length(words), num_samples);
file_paths = string(zeros(1, num_samples));

sample=1

for i = 1:length(words)
    path = sprintf("%s/%s", base_path, words(i));
    audiofiles = dir(fullfile(path, '*.wav'));
    
    for j = 1:length(audiofiles)
        % read in audio file
        fpath = sprintf("%s/%s", audiofiles(j).folder, audiofiles(j).name);
        [a f] = img_audio(fpath, 4000, 4, 500);
        
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