function [resultImage] = audioPaint(filename)
	[soundWave, Fs] = audioread(filename),
    
    print soundWave

end