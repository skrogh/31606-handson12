%%problem 1.1 Noise in - noise out

infiles = {'in_length_100.wav','in_length_1000.wav','in_length_10000','in_length_100000','in_length_500000'};
outfiles = {'out_length_100.wav','out_length_1000.wav','out_length_10000','out_length_100000','out_length_500000'};

n_puts = length(infiles); %number of inputs

inputs = cell(1,5); %noise inputs
outputs = cell(1,5); %processed noise outputs

%read the files
for k = 1:n_puts
    inputs{k} = wavread(infiles{k});
    outputs{k} = wavread(outfiles{k});
end

Cs = cell(1,5); %cross correlated inputs/outputs
lags = cell(1,5); %and their respective lags

%cross correlate!
for k = 1:n_puts
    [Cs{k}, lags{k}] = xcorr(outputs{k},inputs{k},'biased');
end

Rs = cell(1,5); %reverse convolved inputs/outputs

for k = 1:n_puts
    Rs{k} = ifft(fft(outputs{k})./fft(inputs{k}));
end

%apply 100 sample rectangular window to 100 sample input/output and 200
%sample rectangular window
%to other combinations shifted by length/2 to obtain impulse response
wlengths = [100,200,200,200,200];
for k = 1:n_puts
    Cs{k} = Cs{k}(find(lags{k}==0):find(lags{k}==0)+wlengths(k)-1);
    lags{k} = lags{k}(find(lags{k}==0):find(lags{k}==0)+wlengths(k)-1);
    %Do the same for reverse convolved signals, but don't shift window
    Rs{k} = Rs{k}(1:wlengths(k));
end

%plotting time
myColors = {[1,0,0],[0.5,0,0.5],[0,0,1],[0.2,0,0.8],[0.0,0.5,0.5]};
clf(1); clf(2);
for k = 1:n_puts
    [HC,WC] = freqz(Cs{k}); %cross correlated freqz
    [HR,WR] = freqz(Rs{k}); %reverse convolve freqz
    figure(1); hold on
    subplot(2,1,1); hold on
    plot(WC/pi,20*log10(abs(HC)),'Color',myColors{k}); %cross magnitude response
    subplot(2,1,2);
    plot(WC/pi,180*unwrap(angle(HC))/pi,'Color',myColors{k}); %cross phase angle
    figure(2); hold on;
    subplot(2,1,1); hold on;
    plot(WR/pi,20*log10(abs(HR)),'Color',myColors{k}); %reverse conv magnitude
    subplot(2,1,2);
    plot(WR/pi,180*unwrap(angle(HR))/pi,'Color',myColors{k}); %reverse conv phase
end
legendstr = {'100','1k','10k','100k','500k'};

%cosmetics
figure(1); hold off; subplot(2,1,1); ylim([-100,25]); ylabel('Magnitude [dB]'); title('Cross correlated IR frequency response'); xlabel('Normalised Frequency [pi rad/sample]');
subplot(2,1,2); legend(legendstr,'Location','NorthEast','orientation','horizontal'); ylabel('Phase [degrees]'); xlabel('Normalised Frequency [pi rad/sample]');
figure(2); hold off; subplot(2,1,1); ylim([-100,40]);ylabel('Magnitude [dB]'); title('Reverse convolved IR frequency response'); xlabel('Normalised Frequency [pi rad/sample]');
subplot(2,1,2); legend(legendstr,'Location','Northeast','orientation','horizontal'); ylabel('Phase [degrees]'); xlabel('Normalised Frequency [pi rad/sample]');

%export figures
figure(1); set(gcf, 'paperunits','centimeters','Paperposition',[0 0 16, 6])
saveas(gcf,'./pictures/xcorr_responses.eps','psc2');
figure(2); set(gcf, 'paperunits','centimeters','Paperposition',[0 0 16, 6])
saveas(gcf,'./pictures/rconv_responses.eps','psc2');

%plot impulse responses
figure(3); clf(3); 
figure(4); clf(4);
for k = 1:n_puts
    figure(3);
    plot(1:length(Cs{k}),Cs{k},'color',myColors{k}); hold on;
    figure(4);
    plot(1:length(Rs{k}),Rs{k},'color',myColors{k}); hold on;
end
figure(3); title('Cross-correlated impulse responses'); ylabel('Amplitude []'); xlabel('Sample nr []');
legend(legendstr,'location','eastoutside','orientation','vertical');
figure(4); title('Reverse convolved impulse responses'); ylabel('Amplitude []'); xlabel('Sample nr []');
legend(legendstr,'location','eastoutside','orientation','vertical');

%export figures
figure(3); set(gcf, 'paperunits','centimeters','Paperposition',[0 0 16, 4])
saveas(gcf,'./pictures/xcorr_IR.eps','psc2');
figure(4); set(gcf, 'paperunits','centimeters','Paperposition',[0 0 16, 4])
saveas(gcf,'./pictures/rconv_IR.eps','psc2');