function img = decodeJPEG(bytes)
    img = javax.imageio.ImageIO.read(java.io.ByteArrayInputStream(bytes));
    h = img.getHeight;
    w = img.getWidth;
    p = reshape(typecast(img.getData.getDataStorage, 'uint8'), [3, w, h]);
    img = cat(3, ...
        transpose(reshape(p(3, :, :), [w, h])), ...
        transpose(reshape(p(2, :, :), [w, h])), ...
        transpose(reshape(p(1, :, :), [w, h])));
end
