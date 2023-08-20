%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Brief		: Calculate the euclidian distance for every bit 
%% Input arguments	: row-column mapping per bit
%%
%% Output arguments	: dist 
%%			  |------------ -->bit0[2]->set0, set1 
%% 			  		-->bit1[2]->set0, set1 
%% 			  		-->bit2[2]->set0, set1
%% 			  		-->bit3[2]->set0, set1
%%			  TODO : Matrix to vector mapping
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 10-05-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dist = calc_distance(target_sym,rx)
dist = struct(); bit = struct(); set = struct();

ri = real(rx); rq = imag(rx);
global candidates;

%% BIT 0
%	SET 0
symi00 = real(candidates(target_sym.bit(1).set(1).row,target_sym.bit(1).set(1).col));
symq00 = imag(candidates(target_sym.bit(1).set(1).row,target_sym.bit(1).set(1).col));
dist.bit(1).set(1) = (symi00 - ri)^2 + (symq00 - rq)^2;

%	SET 1
symi01 = real(candidates(target_sym.bit(1).set(2).row,target_sym.bit(1).set(2).col));
symq01 = imag(candidates(target_sym.bit(1).set(2).row,target_sym.bit(1).set(2).col));
dist.bit(1).set(2) = (symi01 - ri)^2 + (symq01 - rq)^2;

%% BIT 1
%	SET 0
symi10 = real(candidates(target_sym.bit(2).set(1).row,target_sym.bit(2).set(1).col));
symq10 = imag(candidates(target_sym.bit(2).set(1).row,target_sym.bit(2).set(1).col));
dist.bit(2).set(1) = (symi10 - ri)^2 + (symq10 - rq)^2;

%	SET 1
symi11 = real(candidates(target_sym.bit(2).set(2).row,target_sym.bit(2).set(2).col));
symq11 = imag(candidates(target_sym.bit(2).set(2).row,target_sym.bit(2).set(2).col));
dist.bit(2).set(2) = (symi11 - ri)^2 + (symq11 - rq)^2;

%% BIT 2
%	SET 0
symi20 = real(candidates(target_sym.bit(3).set(1).row,target_sym.bit(3).set(1).col));
symq20 = imag(candidates(target_sym.bit(3).set(1).row,target_sym.bit(3).set(1).col));
dist.bit(3).set(1) = (symi20 - ri)^2 + (symq20 - rq)^2;

%	SET 1
symi21 = real(candidates(target_sym.bit(3).set(2).row,target_sym.bit(3).set(2).col));
symq21 = imag(candidates(target_sym.bit(3).set(2).row,target_sym.bit(3).set(2).col));
dist.bit(3).set(2) = (symi21 - ri)^2 + (symq21 - rq)^2;

%% BIT 3
%	SET 0
symi30 = real(candidates(target_sym.bit(4).set(1).row,target_sym.bit(4).set(1).col));
symq30 = imag(candidates(target_sym.bit(4).set(1).row,target_sym.bit(4).set(1).col));
dist.bit(4).set(1) = (symi30 - ri)^2 + (symq30 - rq)^2;

%	SET 1
symi31 = real(candidates(target_sym.bit(4).set(2).row,target_sym.bit(4).set(2).col));
symq31 = imag(candidates(target_sym.bit(4).set(2).row,target_sym.bit(4).set(2).col));
dist.bit(4).set(2) = (symi31 - ri)^2 + (symq31 - rq)^2;
end
