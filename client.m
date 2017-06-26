addpath('./util/');

HOST = 'localhost';
PORT = 8000;

imgFile = fopen('./test/human.jpg', 'r');
bytes = fread(imgFile);
fclose(imgFile);

conn = tcpip(HOST, PORT, 'NetworkRole', 'client');
conn.InputBufferSize = 5000000;
conn.OutputBufferSize = 5000000;
conn.Timeout = 10;  % seconds

fopen(conn);
pause(0.5);
% fwrite(conn, bytes);
fwrite(conn, 'client hello');
fclose(conn);
