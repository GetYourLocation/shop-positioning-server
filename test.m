addpath('./util/');
setEncoding();

DATA_DIR = 'data';
DETECTOR_PATH = 'detector.mat';
RESULT_PATH = 'test_result.csv';

fprintf('Loading testing data...\n');
[oriTestData, labelsCnt] = readTable(fullfile(DATA_DIR, 'test.csv'));
oriTestData.imageFilename = fullfile(pwd(), DATA_DIR, 'JPEGImages', oriTestData.imageFilename);
testData = choose(oriTestData, 3);  % Choose only a part of samples of each label to test
fprintf('Testing data size: %d*%d\n', size(testData, 1), size(testData, 2));

% Show labels info
labelsCnt

% Load detector and label dict
data = load(DETECTOR_PATH);
detector = data.detector
labelDict = genLabelDict();

fprintf('Testing...\n')
testResult = {'Label' 'Total' 'Passed' 'Failed' 'FailedImages'};
labelNames = testData.Properties.VariableNames;
for i = 2:size(labelNames, 2)
    testResult{i, 1} = labelNames(1, i);
    testResult{i, 2} = 0;
    testResult{i, 3} = 0;
    testResult{i, 4} = 0;
    testResult{i, 5} = {};
end
for i = 1:size(testData, 1)
    imgPathCell = testData{i, 1};
    imgPath = imgPathCell{1};
    img = imread(imgPath);
    [bbox, score, label, bestLabel] = predict(detector, img, false);
    expectLabelIdx = 0;
    pass = false;
    for j = 2:size(testData, 2)
        bboxCell = testData{i, j};
        if numel(bboxCell{1}) ~= 0
            expectLabelIdx = j;
            expectLabelCell = labelNames(j);
            if strcmp(expectLabelCell{1}, bestLabel) == 1
                pass = true;
            end
            break;
        end
    end
    testResult{expectLabelIdx, 2} = testResult{expectLabelIdx, 2} + 1;
    if pass
        testResult{expectLabelIdx, 3} = testResult{expectLabelIdx, 3} + 1;
    else
        testResult{expectLabelIdx, 4} = testResult{expectLabelIdx, 4} + 1;
        failedImagesCell = testResult{expectLabelIdx, 5};
        nextRow = size(failedImagesCell, 1) + 1;
        failedImagesCell{nextRow, 1} = imgPath;
        testResult{expectLabelIdx, 5} = failedImagesCell;
    end
    fprintf('Finish %d\n', i);
end
testResult = cell2table(testResult);
writetable(testResult, RESULT_PATH, 'WriteVariableNames', false);
fprintf('Testing results saved to ''%s''.\n', RESULT_PATH);
