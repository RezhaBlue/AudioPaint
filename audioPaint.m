function [resultImage] = audioPaint(filename)
<<<<<<< HEAD
	[soundWave, Fs] = audioread(filename);
    %print soundWave
    soundWave
    %get the discrete fourier transform using fft
    dft = fft(soundWave);
    freq = 0:Fs/length(soundWave):Fs/2;
    %cut the dft down to half length
    dft = dft(1:length(soundWave)/2+1);
    %plots the frequencies for the dft
    %plot(freq,abs(dft))
    %shows the peaks
    psdest = psd(spectrum.periodogram,soundWave,'Fs',Fs,'NFFT',length(soundWave));
    %plot(psdest)
    
%{ 
denoting xcoord= fft(audiosignal(i)) and ycoord = abs(X(i))
and then plot pikasprite at that given x and y on a canvas
wait xcoord should eb the time not the fft itself
we would use the freq from fft to figure out the sprite we're using
%}
    %find peaks in data
    %[pks,locs,w,p] = findpeaks(dft)
    
=======
    landscape = imread('landscape.png'),
    imshow(landscape),
	[soundWave, Fs] = audioread(filename),
    soundSize = size(soundWave),
    
    monoSound = (soundWave(:,1) + soundWave(:,2))/2,
    
    

>>>>>>> origin/master
end