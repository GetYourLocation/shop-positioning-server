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
        logd(sprintf('Receive %d bytes.', conn.BytesAvailable));
        % data = fread(conn, conn.BytesAvailable, 'uint8');
        % img = decodeJPEG(data);
        % imshow(img);
        data = fread(conn, conn.BytesAvailable, 'char');
        logd(sprintf('Content: %s', data));
        fwrite(conn, 'server hello');
    catch MException
        logd(getReport(MException));
    end
    fclose(conn);
    logd('Connection closed.');
end
