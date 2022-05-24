%% Loading sound and resampling to 8 kHz
play_sounds = 0; % Change to 1 if you want to play sounds
% Voiced sound
load_values = load('labtest.mat');
x = load_values.xx;
Fs = load_values.fs;
true_notes = load_values.notes;
if play_sounds
    sound(x, Fs)
    plot(x)
end

%% 

% define the filters

% Bandpass Filter Bank Design

ww2 = 0:1:4000; %-- frequency axis in Hz
Fs = 8000; 
a0 = 0.54;

% Define the first filter for octave # 2 with a center frequency of 0.03849
n2 = 0:1:250;
L2  = max(n2);
h2 = (a0-(1-a0)*cos((2*pi*n2)*(1/(L2-1)))).*cos(0.074173*(n2-(L2-1)*0.5));
H2 = freqz(h2, 1, ww2,Fs);Hn2 = 1/(max(abs(H2)))*abs(H2);
h2 = (1/max(abs(H2)))*h2;



% Define the second filter for octave 3
n3 = 0:1:250/2;
L3  = max(n3);
h3 = (a0-(1-a0)*cos((2*pi*n3)*(1/(L3-1)))).*cos(0.14834*(n3-(L3-1)*0.5));
H3 = freqz(h2, 1, ww2,Fs);Hn3 = 1/(max(abs(H3)))*abs(H3);
h3 = (1/max(abs(H3)))*h3;


% Define the third filter for octave 4

n4 = 0:1:62;
L4  = max(n4);
h4 = (a0-(1-a0)*cos((2*pi*n4)*(1/(L4-1)))).*cos(0.296689*(n4-(L4-1)*0.5));
H4 = freqz(h4, 1, ww2,Fs);Hn4 = 1/(max(abs(H4)))*abs(H4);
h4 = (1/max(abs(H4)))*h4;

% Define filter for octave 5
n5 = 0:1:31;
L5  = max(n5);
h5 = (a0-(1-a0)*cos((2*pi*n5)*(1/(L5-1)))).*cos(0.593376*(n5-(L5-1)*0.5));
H5 = freqz(h5, 1, ww2,Fs);Hn5 = 1/(max(abs(H5)))*abs(H5);
h5 = (1/max(abs(H5)))*h5;

% Define filter for octave 6

n6 = 0:1:16;
L6  = max(n6);
h6 = (a0-(1-a0)*cos((2*pi*n6)*(1/(L6-1)))).*cos(1.18673*(n6-(L6-1)*0.5));
H6 = freqz(h6, 1, ww2,Fs);Hn6 = 1/(max(abs(H6)))*abs(H6);
h6 = (1/max(abs(H6)))*h6;



sc2 = octavescore(x,h2,Fs);
sc3 = octavescore(x,h3,Fs);
sc4 = octavescore(x,h4,Fs);
sc5 = octavescore(x,h5,Fs);
sc6 = octavescore(x,h6,Fs);


% Put together all the scores

scores = [sc2;sc3;sc4;sc5;sc6];
[Sout,Sind] = sort(scores,1, 'descend');
Sout1 = (Sout(1,:)>0.5).*(Sind(1,:)+1);
Sout2 = (Sout(2,:)>0.5).*(Sind(2,:)+1);










 
    
    