%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Brief		: Calculate the log likelihood ratio 
%% Input arguments	: noise_var	-> Noise variance
%%			  dist		-> Euclidian distance calculated in previous step
%%			  
%%
%% Output arguments	: llr (64 x 4 array) -> columns are bits and rows are difference symbols
%% 
%% NOTE			: As per the Matlab ldpcDecode(), positive value of indicates the bit maybe 0 and negative 
%%			  value as 1. Hence llr here is Bit 1 Set - Bit 0 set
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 10-05-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function llr = llr_calc(noise_var,dist)

llr(1) = 1 / noise_var * (dist.bit(1).set(2) - dist.bit(1).set(1)); % BIT 0
llr(2) = 1 / noise_var * (dist.bit(2).set(2) - dist.bit(2).set(1)); % BIT 1
llr(3) = 1 / noise_var * (dist.bit(3).set(2) - dist.bit(3).set(1)); % BIT 2
llr(4) = 1 / noise_var * (dist.bit(4).set(2) - dist.bit(4).set(1)); % BIT 3

end
