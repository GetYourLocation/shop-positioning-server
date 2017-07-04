addpath('./util/');
% setEncoding();

HOST = '0.0.0.0';
PORT = 8000;

conn = tcpip(HOST, PORT, 'NetworkRole', 'server');
conn.InputBufferSize = 5000000;
conn.OutputBufferSize = 5000000;
conn.Timeout = 10;  % seconds
dispTCPIPConfig(conn);

% Load detector and label dict
data = load('detector.mat');
detector = data.detector;
labelDict = genLabelDict();

fprintf('Server listening on port %d...\n\n', PORT);
while true
    x = 0;
    y = 0;
    try
        fopen(conn);
        logd('Connection established.');
        while conn.BytesAvailable == 0
            pause(0.5);
        end
        if conn.BytesAvailable > 0
            logd(sprintf('Receive %d bytes.', conn.BytesAvailable));
            rawImg = fread(conn, conn.BytesAvailable, 'uint8');
            img = decodeJPEG(rawImg);
            logd('Detecting...');
            [bbox, score, label, bestLabel] = predict(detector, img, false)
            if isKey(labelDict, bestLabel)
                val = labelDict(bestLabel);
                pos = val{1, 2};
                x = pos(1);
                y = pos(2);
            end
        end
    catch MException
        logd(getReport(MException));
    end
    logd(sprintf('Return location: (%f, %f)', x, y));
    fwrite(conn, typecast([single(x) single(y)], 'double'), 'double');
    pause(0.5);  % Waiting data transfer
    fclose(conn);
    logd('Connection closed.');
end
