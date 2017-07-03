function processedData = choose(oriData, samples)
    rowSelected = zeros(samples * (size(oriData, 2) - 1), 1);
    rowCnt = 1;
    for i = 2:size(oriData, 2)
        colCell = table2array(oriData(:, i));
        sampleCnt = 0;
        for j = 1:size(colCell, 1)
            if numel(colCell{j, 1}) ~= 0
                rowSelected(rowCnt) = j;
                rowCnt = rowCnt + 1;
                sampleCnt = sampleCnt + 1;
                if mod(sampleCnt, samples) == 0
                    break;
                end
            end
        end
    end
    processedData = oriData(rowSelected, :);
    perm = randperm(size(processedData, 1));
    processedData = processedData(perm, :);
end
