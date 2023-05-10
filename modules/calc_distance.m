%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Brief		: Calculate the euclidian distance for every bit 
%% Input arguments	: estimated_row, estimated_col, row-column mapping per
%%			  bit
%%
%% Output arguments	: dist 
%%			  |------------ -->bit0[2]->set0, set1 
%% 			  		-->bit1[2]->set0, set1 
%% 			  		-->bit2[2]->set0, set1
%% 			  		-->bit3[2]->set0, set1
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 07-05-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dist = calc_distance(target_row,target_col,target_syms)
dist = struct(); bit = struct(); set = struct();

%% BIT 0
%	SET 0
symi00 = real(rx(target_syms.bit(1).set(1).row,target_syms.bit(1).set(1).col));
symq00 = imag(rx(target_syms.bit(1).set(1).row,target_syms.bit(1).set(1).col));
dist.bit(1).set(1) = (symi00 - ri)^2 + (symq00 - rq)^2;

%	SET 1
symi01 = real(rx(target_syms.bit(1).set(2).row,target_syms.bit(1).set(2).col));
symq01 = imag(rx(target_syms.bit(1).set(2).row,target_syms.bit(1).set(2).col));
dist.bit(1).set(2) = (symi01 - ri)^2 + (symq01 - rq)^2;

%% BIT 1
%	SET 0
symi10 = real(rx(target_syms.bit(2).set(1).row,target_syms.bit(2).set(1).col));
symq10 = imag(rx(target_syms.bit(2).set(1).row,target_syms.bit(2).set(1).col));
dist.bit(2).set(1) = (symi10 - ri)^2 + (symq10 - rq)^2;

%	SET 1
symi11 = real(rx(target_syms.bit(2).set(2).row,target_syms.bit(2).set(2).col));
symq11 = imag(rx(target_syms.bit(2).set(2).row,target_syms.bit(2).set(2).col));
dist.bit(2).set(2) = (symi11 - ri)^2 + (symq11 - rq)^2;

%% BIT 2
%	SET 0
symi20 = real(rx(target_syms.bit(3).set(1).row,target_syms.bit(3).set(1).col));
symq20 = imag(rx(target_syms.bit(3).set(1).row,target_syms.bit(3).set(1).col));
dist.bit(3).set(1) = (symi20 - ri)^2 + (symq20 - rq)^2;

%	SET 1
symi21 = real(rx(target_syms.bit(3).set(2).row,target_syms.bit(3).set(2).col));
symq21 = imag(rx(target_syms.bit(3).set(2).row,target_syms.bit(3).set(2).col));
dist.bit(3).set(2) = (symi21 - ri)^2 + (symq21 - rq)^2;

%% BIT 3
%	SET 0
symi30 = real(rx(target_syms.bit(4).set(1).row,target_syms.bit(4).set(1).col));
symq30 = imag(rx(target_syms.bit(4).set(1).row,target_syms.bit(4).set(1).col));
dist.bit(4).set(1) = (symi30 - ri)^2 + (symq30 - rq)^2;

%	SET 1
symi31 = real(rx(target_syms.bit(4).set(2).row,target_syms.bit(4).set(2).col));
symq31 = imag(rx(target_syms.bit(4).set(2).row,target_syms.bit(4).set(2).col));
dist.bit(4).set(2) = (symi31 - ri)^2 + (symq31 - rq)^2;

endfunction
