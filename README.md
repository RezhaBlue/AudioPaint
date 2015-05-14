# AudioPaint
an attempt to turn audio into sensible imagery
Maps Pokemon sprite onto a landscape according to the beat and frequency of the audio.

Prompts for an audio file, the runs that file thorugh several filters
in order to extract borth beats and frequency. Those beats then calculate a 
x coordinate to place a sprite at based off 
of the image’s dimension, and use the frequencies to calculate a y coordinate, 
then use both values are used to determine what sprite to draw from our database. 
The final image is a rough representation of the beats present in the song, 
and if you listen to the original sound while looking at the image you can 
kind of see how the images map to the sound.

Run in a MATLAB environment where audioread() is supported.

Future possible qualities of soudn to be used for the project:
Frequency, or its inverse, the period.
Wavelength.
Wave number.
Amplitude.
Sound pressure.
Sound intensity.
Speed of sound.
Direction.

