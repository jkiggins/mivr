Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

f = Fs*(0:(L/2))/L;

S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

% Y = fft(S);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);

[y f] = fft_freq(S, Fs);

% plot(f,P1) 
plot(f, y);
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

function [y f] = fft_freq(x, fs)
    L = length(x);
    f = fs*(0:(L/2))/L;
    
    Y = fft(x);
    y = abs(Y(1:L/2+1));
    y = (y - min(y)) ./ (max(y) - min(y));
end