function [resultImage] = audioPaint(filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set bandwidth limits for dividing sample
%read in sample
%divide sample into its frequency bands
%reduce signal down to its envelope
%differentiate envelopes
%convolve signals to see which give highest energy outputs (these are the
%beats)
% https://www.clear.rice.edu/elec301/Projects01/beat_sync/beatalgo.html

	%[soundWave, Fs] = audioread(filename);

    % Organize bandlimits
    if nargin < 3, bandlimits = [0 200 400 800 1600 3200]; end
    if nargin < 4, maxfreq = 4096; end
    
    % Read in audio file
    [soundWave, Fs] = audioread('intldrop.wav');
    monoSound = (soundWave(:,1) + soundWave(:,2))/2;
    
    % Implements beat detection algorithm for the song
    status = 'filtering first song...'
    a = filterbank(monoSound, bandlimits, maxfreq);
    status = 'windowing first song...'
    b = hwindow(a, 0.2, bandlimits, maxfreq);
    status = 'differentiating first song...'
    c = diffrect(b, length(bandlimits));
    status = 'comb filtering first song...'

    % Recursively calls timecomb to decrease computational time
    d = timecomb(c, 2, 60, 240, bandlimits, maxfreq);
    e = timecomb(c, .5, d-2, d+2, bandlimits, maxfreq);
    f = timecomb(c, .1, e-.5, e+.5, bandlimits, maxfreq);
    g = timecomb(c, .01, f-.1, f+.1, bandlimits, maxfreq);

    monosound_bpm = g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find the x and y for the peak of each beat
% extract sprite from image database based on freq
% mask area derived from x and y on canvas
% overlay sprite at x and y

    
    %replace these x and y values with dyanamic ones
    x = 0; y = 0; %xrange = (0, 1739), yrange = (0,977)
    
    %import canvas image
    landscape = imread('landscape.png');
    
    %import sprite
    %%%need image database code for picking a sprite here
    sprite = imread('latias.png');
    [im_y, im_x, dim] = size(sprite);
    %overlay sprite on canvas
    blend_im = zeros(im_y, im_x, dim, 'uint8');
    patch1 = landscape(y+1:y+im_y, x+1:x+im_x, :);
    patch2 = sprite;
    mask = (patch2 == 0);
    blend_im = uint8(mask) .* patch1 + (1-uint8(mask)) .* patch2;
    landscape(y+1:y+im_y, x+1:x+im_x,:) = blend_im;
    imshow(landscape);
     
       
    
    %image sequencing for videos: http://www.mathworks.com/help/images/what-is-an-image-sequence.html
    %databasing images: http://www.mathworks.com/matlabcentral/answers/159725-how-to-create-images-database-in-matlab-to-store-5-images
    %beat detection: http://archive.gamedev.net/archive/reference/programming/features/beatdetection/index.html
end
