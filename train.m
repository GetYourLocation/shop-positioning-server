addpath('./util/');
setEncoding();

DATA_DIR = 'data';
DETECTOR_PATH = 'detector.mat';
CAFFE_MODEL_PATH = 'model.prototxt';

fprintf('Loading training data...\n');
[oriTrainData, labelsCnt] = readTable(fullfile(DATA_DIR, 'train.csv'));
oriTrainData.imageFilename = fullfile(pwd(), DATA_DIR, 'JPEGImages', oriTrainData.imageFilename);
trainData = choose(oriTrainData, 10);  % Choose only a part of samples of each label to train
fprintf('Training data size: %d*%d\n', size(trainData, 1), size(trainData, 2));

% Show labels info
labelsCnt

% Build layers
layers = genLayers('checkpoint', size(trainData, 2), DETECTOR_PATH)

% Training options
options = trainingOptions('sgdm', ...
    'CheckpointPath', 'checkpoint', ...
    'ExecutionEnvironment', 'gpu', ...
    'InitialLearnRate', 1e-6, ...
    'LearnRateSchedule', 'none', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 10, ...
    'L2Regularization', 0.0001, ...
    'MaxEpochs', 1, ...
    'MiniBatchSize', 128, ...
    'Momentum', 0.9, ...
    'Shuffle', 'never', ...
    'Verbose', 1, ...
    'VerboseFrequency', 50)
fprintf('\n')

% Train detector
detector = trainFasterRCNNObjectDetector(trainData, layers, options)
save(DETECTOR_PATH, 'detector');
