function params = randParams(size_, bias)
    if bias
        params = randn(size_) * 0.001;
    else
        params = randn(size_) * 0.01;
    end
end
