function dispTCPIPConfig(conn)
    props = properties(conn);
    fprintf('TCPIP config:\n{\n');
    for i = 1:size(props)
        key = char(props(i));
        fprintf('\t''%s'': ', key);
        val = get(conn, key);
        if ischar(val)
            fprintf('%s', val);
        else
            fprintf('%f', val);
        end
        fprintf('\n');
    end
    fprintf('}\n\n');
end
