function [s] = ISTFT(S, w, h, p);
%INPUT: STFT matrix: S. Window: w. Hop size: h. FFT points: p.
%OUTPUT: Signal: s.
%Initialize constants and signal vector:
M = size(S, 2); 
Lw = length(w); Ls = Lw + (M-1)*h;  %since M = 1+floor((Ls-Lw)/h)
s = zeros(Ls, 1);
%Compute ISTFT using overlap-add:
i = 0;
if mod(p, 2) == 1    %nyquist fencepost error correction
    for j = 1:M
        P = S(:,j);                                     %load time slice
        Q = conj(flipud(P(2:end)));                     %negative freqs
        R = ifft([P; Q]);                               %IFFT time slice
        s((i+1):(i+Lw)) = s((i+1):(i+Lw))+(R(1:Lw).*w); %overlap-add
        i = i + h;                                      %inc by hop size
    end
elseif mod(p, 2) == 0
    for j = 1:M
        P = S(:,j);
        Q = conj(flipud(P(2:end-1)));
        R = ifft([P; Q]);
        s((i+1):(i+Lw)) = s((i+1):(i+Lw))+(R(1:Lw).*w);
        i = i + h;
    end
end
%Normalize signal vector:
s = (s*h)/(sum(w.^2));  %Normalize using norm squared of the window
end %eof

