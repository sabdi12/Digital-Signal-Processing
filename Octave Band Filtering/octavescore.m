function sc = octavescore(xx, hh, fs)
%OCTAVESCORE
%   usage:    sc = octavescore(xx, hh, fs)
%   returns a score based on the max amplitude of the filtered output
%     xx = input signal containing musical notes
%     hh = impulse response of ONE bandpass filter 
%     fs = sampling rate
%   The signal detection is done by filtering xx with a length-L
%   BPF, hh, and then finding the maximum amplitude of the output
%   within 50 millisecond segments.
%   The score is a vector containing the maximum amplitudes
%     of all the segments.

% consider xx to be 50ms signal

% First pad the signal with zereos. The size of convolution operation is N+L-1

nh = length(hh);
nx = length(xx);
xx(nh+nx-1)= 0; 

yy = conv(xx,hh);

yy = yy(nh:end);

% The cut off the signal is a function of the filter length


% There are 20 score/sec*3.77 = 75 scores for a given octave
sc = [];

% Number of samples needed to sample from original signal
N = 400;


for seg = 1:75
    xs=yy(1 +(seg - 1)* N:seg * N);
    sc = [sc max(abs(xs))];

end

