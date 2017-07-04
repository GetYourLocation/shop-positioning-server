function layers = loadLayers(path_)
    data = load(path_);
    layers = data.detector.Network.Layers;
    layers(6) = maxPooling2dLayer(3, ...
        'Stride', 2, ...
        'Padding', 0, ...
        'Name', 'maxpool');
end
