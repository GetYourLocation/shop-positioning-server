addpath('./util/');
% setEncoding();

HOST = '0.0.0.0';
PORT = 8000;

conn = tcpip(HOST, PORT, 'NetworkRole', 'server');
conn.InputBufferSize = 5000000;
conn.OutputBufferSize = 5000000;
conn.Timeout = 10;  % seconds
dispTCPIPConfig(conn);

fprintf('Server listening on port %d...\n', PORT);
while true
    try
        fopen(conn);
        logd('Connection established.');
        while conn.BytesAvailable == 0
            pause(0.5);
        end
        if conn.BytesAvailable > 0
            logd(sprintf('Receive %d bytes.', conn.BytesAvailable));

            % Read image
            data = fread(conn, conn.BytesAvailable, 'uint8');
            img = decodeJPEG(data);
            % imshow(img);
           
            input_data = load('data.mat');
            detector = input_data.data.detector;

            % Run detector.
            [bbox, score, label] = detect(detector, img);

            % Display detection results.
            detectedImg = insertShape(img, 'Rectangle', bbox);
            figure
            imshow(detectedImg)

            % Read string
            % data = fread(conn, conn.BytesAvailable, 'char');
            % logd(sprintf('Content: %s', data));

            % Read double
            % data = fread(conn, 1, 'double');
            % x = typecast(data, 'single');
            % logd(sprintf('Content: (%f, %f)', x(1), x(2)));
            
            if isempty(label)
                data = typecast([single(0) single(0)], 'double');
                fwrite(conn, data, 'double');
            else
                dict = genLabelDict();
                dict_shop = dict(label);
                dict_pos = dict_shop{1, 2};
                data = typecast([single(dict_pos(1)) single(dict_pos(2))], 'double');
                fwrite(conn, data, 'double');
            end
        else
            fwrite(conn, 'server hello');
        end
    catch MException
        logd(getReport(MException));
        data = typecast([single(0) single(0)], 'double');
        fwrite(conn, data, 'double');
    end
    data
    fclose(conn);
    logd('Connection closed.');
end
