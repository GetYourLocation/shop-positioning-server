addpath('./util/');
% setEncoding();

HOST = 'localhost';
PORT = 8000;

imgFile = fopen('./data/test.jpg', 'r');
data = fread(imgFile);
fclose(imgFile);

conn = tcpip(HOST, PORT, 'NetworkRole', 'client');
conn.InputBufferSize = 5000000;
conn.OutputBufferSize = 5000000;
conn.Timeout = 10;  % seconds

fopen(conn);
pause(0.5);

% Send image
fwrite(conn, data);
fclose(conn);
