function [y f] = fft_freq(x, fs)
    L = length(x);
    f = fs*(0:(L/2))/L;
    
    Y = fft(x);
    y = abs(Y(1:floor(L/2)+1));
    y = (y - min(y)) ./ (max(y) - min(y));
end