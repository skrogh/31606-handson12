%% Animal identification
animal = wavread('animal_call.wav');

%we are guessing it's an image imbedded in the spectrum because the wave
%file sounds synthetic
figure(1); clf(1);
spectrogram(animal,floor(sqrt(length(animal)))); axis square; view(-90,90); colormap gray;
% what a surprise!
title('Decrypted Zebra');
figure(1); set(gcf, 'paperunits','centimeters','Paperposition',[0 0 16, 8])
saveas(gcf,'./pictures/zebra.eps','psc2');
