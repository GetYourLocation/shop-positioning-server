function dataTable = readTable(filename)
    fid = fopen(filename, 'r');
    colNames = cell(1);
    colNamesIdx = 1;
    dataCell = cell(1);
    dataCellRow = 1;
    firstLoop = true;
    line = fgetl(fid);
    while ischar(line)
        chunks = strsplit(line, ',');
        if firstLoop  % Read table header
            for i = 1:numel(chunks)
                colNames(colNamesIdx) = chunks(i);
                colNamesIdx = colNamesIdx + 1;
            end
            firstLoop = false;
        else
            for i = 1:numel(chunks)
                str = char(chunks(i));
                if numel(strfind(str, '-')) ~= 0  % Empty bounding box values
                    dataCell{dataCellRow, i} = cell(1);
                elseif numel(strfind(str, ' ')) == 0  % Image path
                    dataCell{dataCellRow, i} = chunks(i);
                else  % Bounding box values
                    boxVals = strsplit(str, ' ');
                    boxValsCell = cell(1);
                    boxValsRow = 1;
                    for j = 1:numel(boxVals)
                        val = str2double(char(boxVals(j)));
                        boxValsCell{1}(boxValsRow, mod(j - 1, 4) + 1) = val;
                        if mod(j, 4) == 0
                            boxValsRow = boxValsRow + 1;
                        end
                    end
                    dataCell{dataCellRow, i} = boxValsCell;
                end
            end
            dataCellRow = dataCellRow + 1;
        end
        line = fgetl(fid);
    end
    fclose(fid);
    dataTable = cell2table(dataCell, 'VariableNames', colNames);
end
