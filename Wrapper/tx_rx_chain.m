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

% GLOBAL
global candidates;

% INIT CONFIGS
max_iterations	= 5;				% For LDPC Decoder
dist		= 2;				% Distance between two symbols in same row/coloumn-Unormalized
M		= 16; 				% Modulation order TODO Make it list from 4 QAM to 64 QAM
SnrdB		= 13.8:0.1:14.8;		% TODO Make it a list by taking values from Paper 
codeRate	= 3/4;				% Code Rate for LDPC 
alpha		= atan(1/sqrt(M)); 		% Angle to rotate the Modulation
hI		= 1;				% Fading for inphase component
hQ		= 1;				% Fading for quadrature component
normVal		= sqrt(10);

% DATA GENERATION
% I -	Data bits using LDPC defined Base matrices for specific code rate
p 	   = dvbs2ldpc(codeRate);
cfgLDPCEnc = ldpcEncoderConfig(p);
infoBits   = randi([0 1],cfgLDPCEnc.NumInformationBits,1);
codeword   = ldpcEncode(infoBits, cfgLDPCEnc);

% II -	Symbol creation and rotation
symbols	   = bit2int(codeword,log2(M));
d          = qammod(symbols,M);
d	   = d/normVal;
d          = d .* exp(1i * alpha);

inputLLR   = zeros(length(d),log2(M));
candidates = [-3-1i*3 -1-1i*3 1-1i*3 3-1i*3;
	      -3-1i*1 -1-1i*1 1-1i*1 3-1i*1;
              -3+1i*1 -1+1i*1 1+1i*1 3+1i*1;
              -3+1i*3 -1+1i*3 1+1i*3 3+1i*3]/normVal;
candidates = candidates .* exp(1i * alpha);

% LDPC decode configs
cfgLDPCDec = ldpcDecoderConfig(p);

fprintf("Max Iterations %d\n", max_iterations);

for snr = 1 : length(SnrdB)

	fprintf("At SNR of %0.1fdB\n", SnrdB(snr));

	% III -	Noise and fading addition
	sigPwr	   = sum(abs(d).^2)/length(d);
	noise	   = diag(sqrt(sigPwr)) .* randn(length(d),1) * 10.^(-SnrdB(snr)/20) +...
		     1i * diag(sqrt(sigPwr)) .* randn(length(d),1) * 10.^(-SnrdB(snr)/20);
	noisePwr   = sum(abs(noise).^2)/length(noise);
	rx	   = d + noise;
	rx	   = hI * real(rx) + 1i * hQ * imag(rx); 

	for s = 1 : length(rx)
		% Row column estimation
		[estimated_row, estimated_col, dv] = row_col_est(rx(s), alpha);
		dv_array{snr}{s} = dv;
	
		% LUT
		target_sym = row_column_mapping(estimated_row, estimated_col);
		
		% Euclidian Distance calculation
		% Per symbol root(M) bits distance for set 0 and 1 is calculated
		dist = calc_distance(target_sym,rx(s));
	
		% Input LLR has to be calculated
		inputLLR(s,:) = llr_calc(noisePwr,dist);
	end
	% Decoding to bits using Channel LLR
	rxBits = ldpcDecode(reshape(inputLLR.',1,[])', cfgLDPCDec, max_iterations);
	
	% BER
	numErr(snr) = biterr(infoBits, rxBits);
	errRate(snr) = numErr(snr)/length(infoBits); 

end

figure;
semilogy(SnrdB, errRate,'-o','MarkerFaceColor','k')
title([num2str(M),'-QAM ','BER performance for code rate of ',num2str(codeRate)])
xlabel("SNR in dB")
ylabel("BER")
grid minor

figure;
plot(SnrdB, numErr,'-^','MarkerFaceColor','m','MarkerSize',12)
title("Number of error bits")
xlabel("SNR in dB")
grid minor
