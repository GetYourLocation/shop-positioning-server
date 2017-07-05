function [bbox, score, label, bestLabel] = predictOne(imgPath)
    addpath('./util/');
    data = load('detector.mat');
    detector = data.detector;
    img = imread(imgPath);
    [bbox, score, label, bestLabel] = predict(detector, img, true);
end
