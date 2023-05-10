%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Brief		: Calculate the log likelihood ratio 
%% Input arguments	: sym_num	-> The current symbol of which LLR is being calculated (value from 1 to 64)
%%			  noise_var	-> Noise variance
%%			  dist		-> Euclidian distance calculated in previous step
%%
%% Output arguments	: llr (64 x 4 array) -> columns are bits and rows are difference symbols
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 10-05-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function llr = llr_calc(sym_num,noise_var,dist)

llr(sym_num,1) = 1 / noise_var * (dist.bit(1).set(1) - dist.bit(1).set(2)); % BIT 0
llr(sym_num,2) = 1 / noise_var * (dist.bit(2).set(1) - dist.bit(2).set(2)); % BIT 1
llr(sym_num,3) = 1 / noise_var * (dist.bit(3).set(1) - dist.bit(3).set(2)); % BIT 2
llr(sym_num,4) = 1 / noise_var * (dist.bit(4).set(1) - dist.bit(4).set(2)); % BIT 3

endfunction
