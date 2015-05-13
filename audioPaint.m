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
    if nargin < 3, bandlimits = [200]; end
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

    %{ 
    Recursively calls timecomb to decrease computational time
    d = timecomb(c, 2, 60, 240, bandlimits, maxfreq);
    e = timecomb(c, .5, d-2, d+2, bandlimits, maxfreq);
    f = timecomb(c, .1, e-.5, e+.5, bandlimits, maxfreq);
    g = timecomb(c, .01, f-.1, f+.1, bandlimits, maxfreq);
    %}
    
    [nr,nc] = size(c);

    if nr == 1
      lx = nc;
    elseif nc == 1
      lx = nr;
      c = c';
    else
      lx = nr;
    end

    if (nr == 1) || (nc == 1)

      m = (c > [c(1),c(1:(lx-1))]) & (c >= [c(2:lx),1+c(lx)]);

      if nc == 1
        % retranspose
        m = m';
      end

    else
      % matrix
      lx = nr;
      m = (c > [c(1,:);c(1:(lx-1),:)]) & (c >= [c(2:lx,:);1+c(lx,:)]);
    end
    
    M = m(1:716160); %chopped off last 318 elem -> multiple of 1920
    M = reshape(M, [373 1920]); %width -> 1920
    M = logical(floor(mean(M).*9)); %avg dec. -> binary; 9 = beat+noise, 10 = noise
    %needs to be logical to be used for indexing
    %repeat for C
    
    for i = 1:length(M)
        if M(i) == 1
            for t = i-10: i-1
                M(t) = 0;
            end
            for y = i+1:i+10
                M(y) = 0;
            end
        end
    end
    C = c(1:716160);
    C = reshape(C, [373 1920]);
    C = floor(mean(C)*20000); %brings max y-range to 1000, not max y-value
    
%{
    %for comparing to original beat filtration, pretty damn good
    subplot(2,2,1)
    plot(c)
    subplot (2,2,2)
    plot(D)
    subplot(2,2,3)
    plot(M)
    subplot (2,2,4)
    plot(C)

%}  
    
    xval = find(M); % x-values
    yval = C(M); %y-values
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use i of m(i) as x value, c(i) as y value
% extract sprite from image database based on freq (monoSound(i)?)
% mask area derived from x and y on canvas
% overlay sprite at x and y

    landscape = imread('landscape.png');
    
    fly_path = '\pokemon\flying\';
    ground_path = '\pokemon\ground\';
    imgType = '*.png';
    pokemon_fly = dir(fullfile(pwd, [fly_path imgType]));
    pokemon_ground = dir(fullfile(pwd, [ground_path imgType]));
   
    for i = 1:length(xval)
            x = (xval(i));
            y = floor((yval(i)));
            if y < 792
                sprite = imread(strcat(fullfile(pwd, fly_path), pokemon_fly(mod(y + x, length(pokemon_fly))+ 1).name));
            else
                sprite = imread(strcat(fullfile(pwd, ground_path), pokemon_ground(mod(y + x, length(pokemon_ground))+1).name));
            end
            
            [im_y, im_x, dim] = size(sprite);

            if x < im_x
                x = 0;
            end
            if x > 1920 - im_x
                x = 1920 - im_x;
            end
            if y < im_y
                y = 0;
            end
            if y > 1080 - im_y
                y = 1080 - im_y;
            end
            %overlay sprite on canvas
            blend_im = zeros(im_y, im_x, dim, 'uint8');
            patch1 = landscape(y+1:y+im_y, x+1:x+im_x, :);
            patch2 = sprite;
            mask = (patch2 == 0);
            blend_im = uint8(mask) .* patch1 + (1-uint8(mask)) .* patch2;
            landscape(y+1:y+im_y, x+1:x+im_x,:) = blend_im;
    end

    
    imshow(landscape);

    %{
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
    %imshow(landscape);
     %}
       
    
    %image sequencing for videos: http://www.mathworks.com/help/images/what-is-an-image-sequence.html
    %databasing images: http://www.mathworks.com/matlabcentral/answers/159725-how-to-create-images-database-in-matlab-to-store-5-images
    %beat detection: http://archive.gamedev.net/archive/reference/programming/features/beatdetection/index.html
end
