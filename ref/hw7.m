%% Question 7
if(shouldRun("7"))
    close all ; clear all;
    
    addpath libsvm-3.18/matlab

    % We will use mnist hand written digits, '0' through '9'
    load('ex4data1.mat');  %5000 Mnist digits from Andrew Ng class
    n = size(X, 1);  %number of samples = 5000, 500 from each class
    D = size(X,2);  %number of dimensions/sample.  20x20=400
    C = length(unique(y));  %number of classes, class values are 1...10, where 10 is a digit '0'

    % Randomly select 100 data points to display
    sel = randperm(size(X, 1));
    sel = sel(1:100);

    displayData(X(sel, :));  %This function is from Andrew Ng's online class

    %Convert X and y data into Matlab nnet format:
    inputs = X';
    %one-hot encoding ground truth values 
    targets = zeros(C,n);
    for ii=1:n
            targets(y(ii),ii) =  1;
    end
    %If given one-hot encoding, can convert back to vector of ground truth
    %class values:
    % target1Dvector=zeros(n,1);
    % for ii=1:n
    %         target1Dvector(ii) = find(targets(:,ii) == 1);
    % end
    % max(target1Dvector-y) %this will be zero

    fprintf('\nLoading Saved Neural Network Parameters ...\n')

    % Load the weights into variables Theta1 and Theta2
    load('ex4weights.mat');  %Pre-learned weights from Andrew Ng class

    % Unroll parameters 
    nn_params = [Theta1(:) ; Theta2(:)];
    
    lambda = 0;
    hidden_layer_size = 25;
    input_layer_size = D;
    num_labels = C;
    J = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, ...
                   num_labels, X, y, lambda);
    fprintf(['Cost at parameters (no regularization): %f \n'], J);
    
    lambda = 1;
    J = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, ...
                   num_labels, X, y, lambda);
    fprintf(['Cost at parameters (with regularization): %f \n'], J);
    
    fprintf('\nInitializing Neural Network Parameters ...\n')
    initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
    initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
     % Unroll parameters
    initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

    fprintf('\nTraining Neural Network... \n')

    %  After you have completed the assignment, change the MaxIter to a larger
    %  value to see how more training helps.
    options = optimset('MaxIter', 50);

    %  You can try different values of lambda, but keep lambda=1 for this exercise
    lambda = 1;

    % Create "short hand" for the cost function to be minimized
    costFunction = @(p) nnCostFunction(p, ...
                                        input_layer_size, ...
                                       hidden_layer_size, ...
                                       num_labels, X, y, lambda);
 
    % Now, costFunction is a function that takes in only one argument (the
    % neural network parameters)
    [nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

    % Obtain Theta1 and Theta2 back from nn_params
    Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                     hidden_layer_size, (input_layer_size + 1));

    Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                     num_labels, (hidden_layer_size + 1));

    % Visual weights- can uncomment out next two lines to see weights            
    % fprintf('\nVisualizing Neural Network... \n')
    % displayData(Theta1(:, 2:end));

    pred = predict(Theta1, Theta2, X);
    fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);

end

%% Question 8
if(shouldRun("8"))
    close all ; clear all;
    
    addpath libsvm-3.18/matlab

    % We will use mnist hand written digits, '0' through '9'
    load('ex4data1.mat');  %5000 Mnist digits from Andrew Ng class
    n = size(X, 1);  %number of samples = 5000, 500 from each class
    D = size(X,2);  %number of dimensions/sample.  20x20=400
    C = length(unique(y));  %number of classes, class values are 1...10, where 10 is a digit '0'

    %Convert X and y data into Matlab nnet format:
    inputs = X';
    %one-hot encoding ground truth values 
    targets = zeros(C,n);
    for ii=1:n
            targets(y(ii),ii) =  1;
    end

    % Create a Pattern Recognition Network, with one hidden layer containing 25
    % nodes
    hiddenLayerSize = 25;
    setdemorandstream(2014784333);   %seed for random number generator
    net = patternnet(hiddenLayerSize);

    % Set up Division of Data for Training, Validation, Testing
    net.divideParam.trainRatio = 0.7;  %note- splits are done in a random fashion
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio = 0.15;

    % Train the Network
    [net,tr] = train(net,inputs,targets);  %return neural net and a training record
    plotperform(tr); %shows train, validation, and test per epoch

    % Test the returned network on the testing split
    testX = inputs(:,tr.testInd); 
    testT = targets(:,tr.testInd);
    testY = net(testX);   %pass input test values into network
    testIndices = vec2ind(testY);  %converts nnet float for each class into most likely class per sample
    figure; plotconfusion(testT,testY)
    [c,cm] = confusion(testT,testY);

    fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));  %Should be approx 91.6%
    fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);  %Should be approx 8.4%
    %Should be approx 91.6%

    % If your nnet had 2 class output, try this set:
    %[inputs,targets] = cancer_dataset;  %breast cancer dataset built into Matlab
    % you can use the receiver
    % operating characteristic (ROC) plot to measure of how well 
    % the neural network has fit data is the data.  This shows how the 
    % false positive and true positive rates relate as the thresholding of 
    % outputs is varied from 0 to 1.
    % The farther left and up the line is, the fewer false positives need to 
    % be accepted in order to get a high true positive rate. The best classifiers 
    % will have a line going from the bottom left corner, to the top left corner, 
    % to the top right corner, or close to that.
    % Note: for this to work, testY needs to be a softMax, or similar
    % continuous ouput
    %plotroc(testT,testY)

    % View the Network
    view(net); %shows each layer with number of inputs and outputs to each
end

%% Question 8b
if(shouldRun("8b"))
    close all ; clear all;
    
    addpath libsvm-3.18/matlab

    % We will use mnist hand written digits, '0' through '9'
    load('ex4data1.mat');  %5000 Mnist digits from Andrew Ng class
    n = size(X, 1);  %number of samples = 5000, 500 from each class
    D = size(X,2);  %number of dimensions/sample.  20x20=400
    C = length(unique(y));  %number of classes, class values are 1...10, where 10 is a digit '0'

    options.numberOfFolds = 5;
    options.method = 'SVM';
    [confusionMatrix_svm,accuracy_svm] =  classify677_hwk7(X,y,options);

    options.method = 'nnet';
    options.nnet_hiddenLayerSize = 25;
    [confusionMatrix_nnet1,accuracy_nnet1] =  classify677_hwk7(X,y,options);

    fprintf('Linear SVM accuracy is: %0.2f%%\n',accuracy_svm*100);
    fprintf('Nnet accuracy with %d hidden layers, num nodes per layer = %d is: %0.2f%%\n',length(options.nnet_hiddenLayerSize),options.nnet_hiddenLayerSize,accuracy_nnet1*100);

    options.method = 'nnet';
    options.nnet_hiddenLayerSize = [25 10];
    [confusionMatrix_nnet2,accuracy_nnet2] =  classify677_hwk7(X,y,options);
    fprintf('Nnet accuracy with %d hidden layers, num nodes per layer = [%d %d] is: %0.2f%%\n',length(options.nnet_hiddenLayerSize),options.nnet_hiddenLayerSize,accuracy_nnet2*100);
end
%% Functions
function out = shouldRun(qnum)
    qsel = ["8b"];
    out = ismember(qnum, qsel);
end