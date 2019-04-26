% Convolutional Neural Network Approach

delete(gcp('nocreate'))
close all ; clear all;

pool = parpool

load('fft_xy');

predictionLabels = zeros(1, num_samples);
yGT = vec2ind(y);

%% Kfold
numberOfFolds = 5;

rng(2000);  %random number generator seed so results are repeatable
%Generate a fold value for each training sample
CVindex = crossvalind('Kfold', num_samples, numberOfFolds);
i=1;  %this is for easier debugging....

for i = 1:numberOfFolds
    
    fprintf("i = %i of %i\n", i, numberOfFolds);

    testIndex = find(CVindex == i);
    trainIndex = find(CVindex ~= i);
    
    xTest = x(:, testIndex);
    xTrain = x(:, trainIndex);

    yTest = y(:, testIndex);
    yTrain = y(:, trainIndex);

    net = net_init(500, 1000);
    [net,tr] = train(net, xTrain, yTrain, 'useGPU','yes');  %return neural net and a training record
    
    yTestPred = net(xTest, 'useGPU','yes');
    predictionLabels(testIndex) = vec2ind(yTestPred);
end

confusionMatrix = confusionmat(yGT,predictionLabels);
accuracy = sum(diag(confusionMatrix))/sum(sum(confusionMatrix));
fprintf(sprintf('Accuracy = %6.2f%%%% \n',accuracy*100));

%% Functions
function net = net_init(hlayer_size, epochs)
    setdemorandstream(2014784333);   %seed for random number generator
    net = patternnet(hlayer_size);
    
    net.divideParam.trainRatio = 0.8;  %note- splits are done in a random fashion
    net.divideParam.valRatio = 0.2;
    net.divideParam.testRatio = 0.0;
    
    net.trainParam.epochs = epochs;
end