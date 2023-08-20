%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Brief		: Complete Tx and Rx chain that calls all the modules
%% Proposed flow	:
%%			  |------> Init configs
%%			  |------> Data generation 
%%			  |------> Noise and fading addition
%%			  |------> Row column estimation 
%%			  |------> LUT 
%%			  |------> Euclidian Distance calculation 
%%			  |------> Calculate LLR 
%%			  |------> Soft decode and BER 
%% Input arguments	: 
%%
%% Output arguments	:  
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 20-07-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;

% INIT CONFIGS
max_iterations	= 30;				% For LDPC Decoder
dist		= 2;				% Distance between two symbols in same row/coloumn-Unormalized
M		= 16; 				% Modulation order TODO Make it list from 4 QAM to 64 QAM
SnrdB		= 25;				% TODO Make it a list by taking values from Paper 
codeRate	= 3/4;				% Code Rate for LDPC 
alpha		= atan(1/sqrt(M)); 		% Angle to rotate the Modulation
hI		= 1;				% Fading for inphase component
hQ		= 1;				% Fading for quadrature component
normVal		= sqrt(10);

% DATA GENERATION
symbols	   = 0:M-1;
d          = qammod(symbols,M);
d	   = d/normVal;
d          = d .* exp(1i * alpha);
if size(d,2) > 1
	d = reshape(d,[],1);
end

inputLLR   = zeros(length(d),log2(M));

% III -	Noise and fading addition
sigPwr	   = sum(abs(d).^2)/length(d);
noise	   = diag(sqrt(sigPwr)) .* randn(length(d),1) * 10^(-SnrdB/20) +...
	     1i * diag(sqrt(sigPwr)) .* randn(length(d),1) * 10^(-SnrdB/20);
noisePwr   = sum(abs(noise).^2)/length(noise);
rx	   = d + noise;
rx	   = hI * real(rx) + 1i * hQ * imag(rx); 

% IV -	Reference symbols:
%	taking from the pre-noise and faded symbols
%	because it is assumed the receiver know the original value 
%	of reference symbols
common_point = unique(d,'stable'); 

temp1       = reshape(sort(real(common_point)),[],sqrt(M));
x2          = sort(imag(common_point));
x3          = reshape(x2,[],4)';
temp2(:,1)  = flip(x3(:,1));
temp2(:,2)  = flip(x3(:,2));
temp2(:,3)  = flip(x3(:,3));
temp2(:,4)  = flip(x3(:,4));
sym_matrix  = temp1 + 1i* temp2;

ref_row = sym_matrix(:,1);
ref_col = sym_matrix(4,:); 

dv_array = {};

% Loop through iterations for LDPC
for i = 1 : max_iterations
	
	for s = 1 : length(rx)
		% Row column estimation
		[estimated_row, estimated_col, dv] = row_col_est(ref_row, ref_col, rx(s), alpha);
		dv_array{s} = dv;
		% LUT
		target_sym = row_column_mapping(estimated_row, estimated_col);
		
		% Euclidian Distance calculation
		% Per symbol root(M) bits distance for set 0 and 1 is
		% calculated
		dist = calc_distance(target_sym,rx,s);

		% Input LLR has to be calculated
		inputLLR = llr_calc(s,noisePwr,dist);
	end
end
