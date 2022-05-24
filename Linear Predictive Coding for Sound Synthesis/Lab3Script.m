%% Loading sound and resampling to 8 kHz
play_sounds = 0; % Change to 1 if you want to play sounds
Fs = 8000;
% Voiced sound
fname = 'voiced.mp3';
[s_orig, F_sample_orig] = audioread(fname);
voiced = resample(s_orig, Fs, F_sample_orig);
if play_sounds > 0
    sound(s_orig, F_sample_orig)
    pause(length(s_orig)/F_sample_orig + 0.1)
    sound(voiced, Fs)
    pause(length(s_orig)/F_sample_orig + 0.1)
end
% Unvoiced sound
fname = 'unvoiced.mp3';
[s_orig, F_sample_orig] = audioread(fname);
unvoiced = resample(s_orig, Fs, F_sample_orig);
if play_sounds > 0
    sound(s_orig, F_sample_orig)
    pause(length(s_orig)/F_sample_orig + 0.1)
    sound(unvoiced, Fs)
    pause(length(s_orig)/F_sample_orig + 0.1)
end
% Full sentence
fname = 'we-were-away.wav';
[s_orig, F_sample_orig] = audioread(fname);
sentence = resample(s_orig, Fs, F_sample_orig);
if play_sounds > 0
    sound(s_orig, F_sample_orig)
    pause(length(s_orig)/F_sample_orig + 0.1)
    sound(sentence, Fs)
    pause(length(s_orig)/F_sample_orig + 0.1)
end


%% Voiced LPC model
% Question 1: Number of samples per 20ms block
% Don't forget to assign N in LPC.m as well

N_per_block = 160;
BLOCKS1 = 33; % voiced blocks
BLOCKS2 =  47; % unvoiced blocks
% Question 2: Building a pulse train
pulse_hz = 200;
period = 40;

E1 = zeros(1,N_per_block);
E1(1) = 1;
for index = 1:N_per_block-1
    if  mod(index,40) == 0
        E1(index) = 1;
    end
end

% Call LPC here
% The inputs are voiced and # of blocks for voiced
[E_V,X2_V,RECON_V,SYNTH_V] = LPC(voiced,BLOCKS1,E1);

% the inputs are unvoiced and the # of blocks for unvoiced
[E_V2,X2_V2,RECON_V2,SYNTH_V2] = LPC(unvoiced,BLOCKS2,E1);


%% Unvoiced LPC Model
% For voiceless, use random noise (randn)

% Create a white noise and store it in the variable E2
E2 = wgn(160,1,0);
E2 = E2';

% Call LPC here
[E_U,X2_U,RECON_U,SYNTH_U] = LPC(unvoiced,BLOCKS2,E2);


%% Compression

min_sca = min(E_V);
max_sca = max(E_V);

e_norm = (E_V- min_sca)/(max_sca - min_sca);
e_norm = (2*e_norm)-1;
E_quant4 = quantize(e_norm,4);

subplot(311); plot(e_norm); title('Normalized E'); subplot(312); plot(E_quant4); title('E quantized with 4 bits');
subplot(313);plot(abs(e_norm-E_quant4)); title('abs(E-Equant4)');


% Rescale E_quant
E_quant4 = 0.5*(E_quant4+1);
E_quant4 = E_quant4*(max_sca - min_sca) + min_sca;


% Call Functin LPC on the rescaled E_quant array
[E_Q,X2_Q,RECON_Q,SYNTH_Q] = LPC(voiced,BLOCKS1,E_quant4);





