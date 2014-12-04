close all
clear all
%% 2.1 

%settings:
listen = false;
snr = -10;%dB
window_length = 256;
window_padded = window_length * 4; % increased for prettier spectrograms. no audible difference
window = sqrt( hann( window_length ) ); %use sqrt(hann) window
window_overlap = window_length * 0.5 ; % min 50% overlap for sqrt hann window
STFT_image_size = [0, 0, 15, 10]; % for plot generation
color = jet(256);

% load speach (use audio read as waveread is depricated)
[ s fs ] = audioread( 'cocktailparty.wav' );

% make some noise
noise = random( 'norm', 0, 1, size( s ) );

% get average power of signal
s_mag = sqrt( mean( s.^2 ) );

% get average power of noise
noise_mag = sqrt( mean( noise.^2 ) );

% set noise gain
noise_gain = 1/noise_mag * db2mag(snr) * s_mag;

% apply gain to noise
noise = noise * noise_gain;

% signal + noise
s_n = s + noise;

% STFT
S = STFT( s, window, window_overlap, window_padded );
NOISE = STFT( noise, window, window_overlap, window_padded );
S_N = STFT( s_n, window, window_overlap, window_padded );

% estimate noise
E_noise = mean( abs( NOISE(:) ) );

% use estimate to gate the signal:
E_sig1 = S_N .* ( abs(S_N) > ( E_noise * 1 ) );
E_sig2 = S_N .* ( abs(S_N) > ( E_noise * 2 ) ); 
E_sig3 = S_N .* ( abs(S_N) > ( E_noise * 3 ) ); 

% convert back to time:
e_sig1 = ISTFT( E_sig1, window, window_overlap, window_padded );
e_sig2 = ISTFT( E_sig2, window, window_overlap, window_padded );
e_sig3 = ISTFT( E_sig3, window, window_overlap, window_padded );


% Optional listen to it:
if ( listen )
    display( 'NOT playing original w.o. noise, as this clouds jugdement' );
    display( 'playing original + noise' );
    soundsc( s_n, fs );
    display( 'playing denoised for threshold = noise mean' );
    soundsc( e_sig1, fs );
    display( 'playing denoised for threshold = noise mean * 2' );
    soundsc( e_sig2, fs );
    display( 'playing denoised for threshold = noise mean * 3' );
    soundsc( e_sig3, fs );
end


% generate glorious plots!
x=linspace( 0, length( s ) / fs, size( S, 2 ) );
y=linspace( 0, fs / 2, size( S, 1 ) );


% Signal
figure; imagesc( x, y, mag2db( abs( S(:,:) ) ) );
set(gca,'Ydir','normal');
xlabel( 'Time [s]' )
ylabel( 'Frequency [Hz]' )
h = colorbar( 'southoutside' );
h.Label.String = 'Magnitude [dB]';
colormap( color );

set(gca,'Fontsize',10)
set(gcf,'paperunits','centimeters','Paperposition',STFT_image_size)
saveas(gcf,'./pics/2-1-signal.eps','psc2')

% Noise
figure; imagesc( x, y, mag2db( abs( NOISE(:,:) ) ) );
set(gca,'Ydir','normal');
xlabel( 'Time [s]' )
ylabel( 'Frequency [Hz]' )
h = colorbar( 'southoutside' );
h.Label.String = 'Magnitude [dB]';
colormap( color );

set(gca,'Fontsize',10)
set(gcf,'paperunits','centimeters','Paperposition',STFT_image_size)
saveas(gcf,'./pics/2-1-noise.eps','psc2')

% Signal + noise
figure; imagesc( x, y, mag2db( abs( S_N(:,:) ) ) );
set(gca,'Ydir','normal');
xlabel( 'Time [s]' )
ylabel( 'Frequency [Hz]' )
h = colorbar( 'southoutside' );
h.Label.String = 'Magnitude [dB]';
colormap( color );

set(gca,'Fontsize',10)
set(gcf,'paperunits','centimeters','Paperposition',STFT_image_size)
saveas(gcf,'./pics/2-1-signal-noise.eps','psc2')

% Estimate1
figure; imagesc( x, y, mag2db( abs( E_sig1(:,:) ) ) );
set(gca,'Ydir','normal');
xlabel( 'Time [s]' )
ylabel( 'Frequency [Hz]' )
h = colorbar( 'southoutside' );
h.Label.String = 'Magnitude [dB]';
colormap( color );

set(gca,'Fontsize',10)
set(gcf,'paperunits','centimeters','Paperposition',STFT_image_size)
saveas(gcf,'./pics/2-1-est1.eps','psc2')

% Estimate2
figure; imagesc( x, y, mag2db( abs( E_sig2(:,:) ) ) );
set(gca,'Ydir','normal');
xlabel( 'Time [s]' )
ylabel( 'Frequency [Hz]' )
h = colorbar( 'southoutside' );
h.Label.String = 'Magnitude [dB]';
colormap( color );

set(gca,'Fontsize',10)
set(gcf,'paperunits','centimeters','Paperposition',STFT_image_size)
saveas(gcf,'./pics/2-1-est2.eps','psc2')

% Estimate2
figure; imagesc( x, y, mag2db( abs( E_sig3(:,:) ) ) );
set(gca,'Ydir','normal');
xlabel( 'Time [s]' )
ylabel( 'Frequency [Hz]' )
h = colorbar( 'southoutside' );
h.Label.String = 'Magnitude [dB]';
colormap( color );

set(gca,'Fontsize',10)
set(gcf,'paperunits','centimeters','Paperposition',STFT_image_size)
saveas(gcf,'./pics/2-1-est3.eps','psc2')

% Clear huge arrays. working from laptop. ram ~not much.
clear all
