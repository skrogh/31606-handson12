function [S] = STFT(s, w, h, p);
%INPUT: Signal: s. Window: w. Hop size: h. FFT points: p.
%OUTPUT: STFT matrix: S.
%Initialize constants and STFT matrix:
Lw = length(w); Ls = length(s);
N = ceil((p+1)/2); M = 1+floor((Ls-Lw)/h);
S = zeros(N, M);
%Compute STFT:
i = 0;
for j=1:M
    Q = fft(s(i+1:i+Lw).*w, p); %window interval and transform
    S(:,j) = Q(1:N);            %copy positive frequencies
    i = i + h;                  %increment interval by hop size
end
end %eof

