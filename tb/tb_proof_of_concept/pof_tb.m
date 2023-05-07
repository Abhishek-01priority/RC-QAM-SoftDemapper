%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Proof of concept Test bench
%%
%% Brief		: Test bench required for proof of concept validation
%%			  ->incoporate addition of noise to the Tx signal
%%			  ->randomly select a rx symbol
%%			  ->check if the estimated row & column matches the actual row and column 
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 22-04-2023
%% Date of modification :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
pkg load communications
clear all;
close all;
clc;
%rng(1996);
global alpha;
global d;
global pl_fg;
global rx;
global rI;
global rQ;
global ref_row;
global ref_col;

% I - config variables
max_iterations	= 30;
dist		= 2;				% Distance between two symbols in same row/coloumn-Unormalized
M		= 16; 				% Modulation order
SnrdB		= 15 
alpha		= atan(1/sqrt(M)); 		% Angle to rotate the Modulation
hI		= 0.9;				% Fading for inphase component
hQ		= 0.5;				% Fading for quadrature component
pl_fg		= 1;				% Plot flag to plot everything or nothing

% II - Data generation
d	= qammod(0:M-1,M); 	% unrotated QAM constellation
d	= d .* exp(1i * alpha);		% Rotated QAM

% III - Noise and fading addition
sigPwr	= sum(abs(d).^2)/length(d);
noise	= diag(sqrt(sigPwr)) .* randn(1,length(d)) * 10^(-SnrdB/20) +...
	  1i * diag(sqrt(sigPwr)) .* randn(1,length(d)) * 10^(-SnrdB/20);
rx	= d + noise;
rx	= hI * real(rx) + 1i * hQ * imag(rx); 

printf("true_row|estimated_row - true_col|estimated_col\n");
for iter = 1:max_iterations
	% IV - randomly select a symbol from rx
	idx	= randi(M);
	rI	= real(rx(idx)); 
	rQ	= imag(rx(idx));
	
	% V - get the reference symbols from rx
	ref_row	= rx(1:4);
	ref_col	= rx(4:4:16);
	
	% VI - run the proof of concept
	[estimated_row, estimated_col, dv] = proof_of_concept();
	
	if idx <= 4
		true_col = 1;
	elseif idx > 4 && idx <=8
		true_col = 2;
	elseif idx > 8 && idx <=12
		true_col = 3;
	else
		true_col = 4;
	endif
	
	true_row = mod(idx,4);
	if true_row == 0
		true_row = 4;
	endif
	
	printf("%d|%d - %d|%d\n", true_row,estimated_row, true_col,estimated_col);				  
	figure(1); hold on; plot(d,'cx');

	if (true_row != estimated_row || true_col != estimated_col)
		keyboard
	endif

	%keyboard
	clf(1);
endfor


