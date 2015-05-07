function [resultImage] = audioPaint(filename)
    landscape = imread('landscape.png'),
    imshow(landscape),
	[soundWave, Fs] = audioread(filename),
    soundSize = size(soundWave),
    
    monoSound = (soundWave(:,1) + soundWave(:,2))/2,
    
    

end