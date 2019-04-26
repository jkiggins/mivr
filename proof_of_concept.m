% Convolutional Neural Network Approach

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

% x = zeros(1001, num_samples);
% y = zeros(length(words), num_samples);
% file_paths = strforwarding(zeros(1, num_samples));
% 
% sample=1
% 
% for i = 1:length(words)
%     path = sprintf("%s/%s", base_path, words(i));
%     audiofiles = dir(fullfile(path, '*.wav'));
%     
%     for j = 1:length(audiofiles)
%         % read in audio file
%         fpath = sprintf("%s/%s", audiofiles(i).folder, audiofiles(i).name);
%         [a f] = encode_audio(fpath, 4000, 4);
%         
%         try
%             x(1:size(a, 1), sample) = a;
%             file_paths(1, sample) = fpath;
%         catch ME
%             size(a)
%             max(f)
%             fpath
%             sample
%             return
%         end
%         
%         % one-hot target value, same for every sample in a given file
%         y(i, sample) = 1;   
%         
%         sample = sample+1;
%         
%         if(mod(sample, 1000) == 0)
%             fprintf("at sample %i of %i\n", sample, num_samples);
%         end
%     end
% end

% num_samples = sample - 1;

% x = x(:, 1:(num_samples));
% y = y(:, 1:(num_samples));

load('fft_xy');

predictionLabels = zeros(1, num_samples);
yGT = vec2ind(y);

%% Kfold
numberOfFolds = 10;

rng(2000);  %random number generator seed so results are repeatable
%Generate a fold value for each training sample
CVindex = crossvalind('Kfold', num_samples, numberOfFolds);
i=1;  %this is for easier debugging....

for i = 1:numberOfFolds

    testIndex = find(CVindex == i);
    trainIndex = find(CVindex ~= i);
    
    xTest = x(:, testIndex);
    xTrain = x(:, trainIndex);

    yTest = y(:, testIndex);
    yTrain = y(:, trainIndex);

    net = net_init(500);
    [net,tr] = train(net, xTrain, yTrain);  %return neural net and a training record
    
    yTestPred = net(xTest);
    predictionLabels(testIndex) = vec2ind(yTestPred);
end

confusionMatrix = confusionmat(yGT,predictionLabels);
accuracy = sum(diag(confusionMatrix))/sum(sum(confusionMatrix));
fprintf(sprintf('Accuracy = %6.2f%%%% \n',accuracy*100));

%% Functions
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