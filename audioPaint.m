function [resultImage] = audioPaint(filename)
	[soundWave, Fs] = audioread(filename);
    %print soundWave
    soundWave;
    [soundWave, Fs] = audioread('intldrop.wav');
    monoSound = (soundWave(:,1) + soundWave(:,2))/2;
    monoSize = size(monoSound);
    %get the discrete fourier transform using fft
    dft = fft(monoSound);
    freq = 0:Fs/length(monoSound):Fs/2;
    %cut the dft down to half length
    dft = dft(1:length(monoSound)/2+1);
    %plots the frequencies for the dft
    %%%plot(freq,abs(dft));
    %shows the peaks
    psdest = psd(spectrum.periodogram,monoSound,'Fs',Fs,'NFFT',length(soundWave));
    %plot(psdest)
    
%{ 
denoting xcoord= fft(audiosignal(i)) and ycoord = abs(X(i))
and then plot pikasprite at that given x and y on a canvas
wait xcoord should eb the time not the fft itself
we would use the freq from fft to figure out the sprite we're using
%}
    %find peaks in data
    %findpeaks(monoSound)
    %[pks,locs,w,p] = findpeaks(dft)
    
    %replace these x and y values with dyanamic ones
    x = 100; y = 100;
    landscape = imread('landscape.png');
    
    latias = imread('latias.png');
    [im_x, im_y, dim] = size(latias);
    
    blend_im = zeros(im_x, im_y, dim, 'uint8');
    patch1 = landscape(x+1:x+im_x, y+1:y+im_y, :);
    patch2 = latias;
    mask = (patch2 == 0);
    blend_im = uint8(mask) .* patch1 + (1-uint8(mask)) .* patch2;
    landscape(x+1:x+im_x, y+1:y+im_y,:) = blend_im;
    imshow(landscape);
    
    %landscape(100, 50, latios);
    %imshow(landscape);
        
    %image sequencing for videos: http://www.mathworks.com/help/images/what-is-an-image-sequence.html
    %databasing images: http://www.mathworks.com/matlabcentral/answers/159725-how-to-create-images-database-in-matlab-to-store-5-images
    %overlaying: http://stackoverflow.com/questions/11486956/how-to-overlay-several-images-in-matlab
    
end
