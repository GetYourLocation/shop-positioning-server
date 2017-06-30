function params = randParams(size_, std_)
    params = randn(size_) * 0.0001 + std_;
end
