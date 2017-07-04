function [bbox, score, label, bestLabel] = predict(detector, img, show)
    [bbox, score, label] = detect(detector, img);
    if isempty(label)
        bestLabel = 'Background';
    else
        [maxScore, maxScoreIdx] = max(score);
        bestLabel = char(label(maxScoreIdx));
    end
    if show
        detectedImg = insertShape(img, 'Rectangle', bbox);
        figure;
        imshow(detectedImg);
    end
end
