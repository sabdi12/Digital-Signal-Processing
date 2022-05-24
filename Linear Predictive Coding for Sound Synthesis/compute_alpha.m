function [ALPH,G] = compute_alpha(X1, N, NP, BLOCK)
% This function computes not gone over in this lab, including the
% calculation of the alpha_i (in ALPH) and the hamming window.

% Design of Hamming window for use in determining 
% the autocorrelation coefficients

W=hamming(N);
W=W';

for I=1:N
    X(I) = X1(I+(BLOCK-1)*N);    % Segmentation of input sequence
end

X = X.*W;   % Windows input data
%
% Calculation of the autocorrelation coefficients
%
for I = 1:(NP+1)
    R(I) = (X(1:N-I+1)*X(I:N)')./N;
end
%
% Calculation of the prediction filter coefficients using the Toeplitz
% matrix consisting of the autocorrelation coefficients.
%
if all(R(1:10) == 0)
    ALPH = zeros(1,10);
else
    Rtoe=toeplitz(R(1:10));
    ALPH=inv(Rtoe)*R(2:11)';
    ALPH=ALPH';
end
%
% Derivation of the gain term by matching the energy of the input signal
% with the energy of the linearly predicted samples
%
G=R(1);
for I=1:NP
    G=G+ALPH(I).*R(I+1);
end
G=sqrt(abs(G));
end