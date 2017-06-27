addpath('./util/');

HOST = 'localhost';
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

            data = fread(conn, conn.BytesAvailable, 'uint8');
            img = decodeJPEG(data);
            imshow(img);

            % data = fread(conn, conn.BytesAvailable, 'char');
            % logd(sprintf('Content: %s', data));

            % data = fread(conn, 1, 'double');
            % x = typecast(data, 'single');
            % logd(sprintf('Content: (%f, %f)', x(1), x(2)));
            
            data = typecast([single(100) single(200)], 'double');
            fwrite(conn, data, 'double');
        else
            fwrite(conn, 'server hello');
        end
    catch MException
        logd(getReport(MException));
    end
    fclose(conn);
    logd('Connection closed.');
end
