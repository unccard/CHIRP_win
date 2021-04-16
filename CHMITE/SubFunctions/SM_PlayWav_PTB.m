function [token_Duration_Secs,h] = SM_PlayWav_PTB(filename, wavDir, freq)

% filename, wavDir of wav file
% freq is the desired sample rate
% repeat_Option: 0 for continuous play, else 1

wavFileName = sprintf('%s%s',wavDir,filename);

[y,Fs] = audioread(wavFileName);
wavedata = y';

% Resample
if freq ~= Fs
    data = resample(wavedata,freq,Fs);
else
    data = wavedata;
end

% Determine duration of token
token_Duration_Secs = (length(data))/freq;      % samples / (samples/sec)

% Fill the audio playback buffer with the audio data:
%PsychPortAudio('FillBuffer', pahandle, data);

% Start audio playback for 1 repetitions of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.
%t1 = PsychPortAudio('Start', pahandle, repeat_Option, 0, 1);

h = audioplayer(data,freq);	% load up player
play(h)









