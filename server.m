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

fprintf('Server listening on port %d...\n', PORT);
while true
    res = typecast([single(0) single(0)], 'double');  % Default response
    try
        fopen(conn);
        logd('Connection established.');
        while conn.BytesAvailable == 0
            pause(0.5);
        end
        if conn.BytesAvailable > 0
            logd(sprintf('Receive %d bytes.', conn.BytesAvailable));

            % Read image
            rawImg = fread(conn, conn.BytesAvailable, 'uint8');
            img = decodeJPEG(rawImg);
            logd('Detecting...');
            [bbox, score, label] = detect(detector, img);
            logd('Done.');

            % Display detection results
            % detectedImg = insertShape(img, 'Rectangle', bbox);
            % figure;
            % imshow(detectedImg);
            
            if ~isempty(label)
                val = labelDict(label);
                pos = val{1, 2};
                res = typecast([single(pos(1)) single(pos(2))], 'double');
            end
        end
        fwrite(conn, res, 'double');
    catch MException
        logd(getReport(MException));
        fwrite(conn, res, 'double');
    end
    fclose(conn);
    logd('Connection closed.');
end
