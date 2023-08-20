%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Brief		:
%% For the given row and column, this function should return the rows and
%% columns from which euclidian distance has to be calculated  
%% 
%% Every bit has 2 rows/columns per set 0 and set 1. The symbols belonging to 
%% those columns and rows are taken for euclidian distance calculation from Rx
%% symbol. 
%% 
%% Across every bit's every set (set 0 and set 1), the minimum of those
%% rows/columns are taken for final LLR calculation 
%%
%% Instead of calculating the euclidian for all rows and/or columns in every
%% set, calculate the one closets to rx sym. 
%% 
%% Input arguments	: estimated_row, estimated_col
%% Output arguments	: target_syms
%%			  |------------ -->bit0[2]->set0, set1 
%% 			  		-->bit1[2]->set0, set1 
%% 			  		-->bit2[2]->set0, set1
%% 			  		-->bit3[2]->set0, set1
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 07-05-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function target_syms = row_column_mapping(estimated_row, estimated_col)
target_syms = struct(); bit = struct(); set = struct();

% BIT 0
target_syms.bit(1).set(1).row = estimated_row;
target_syms.bit(1).set(2).row = estimated_row;
if estimated_col == 1 || estimated_col == 2
	target_syms.bit(1).set(1).col = estimated_col;
	target_syms.bit(1).set(2).col = 3;
else
	target_syms.bit(1).set(1).col = 2;
	target_syms.bit(1).set(2).col = estimated_col;
end

% BIT 1
target_syms.bit(2).set(1).row = estimated_row;
target_syms.bit(2).set(2).row = estimated_row;
if estimated_col == 1
	target_syms.bit(2).set(1).col = estimated_col;
	target_syms.bit(2).set(2).col = 2;
elseif estimated_col == 4
	target_syms.bit(2).set(1).col = estimated_col;
	target_syms.bit(2).set(2).col = 3;
elseif estimated_col == 2
	target_syms.bit(2).set(1).col = 1;
	target_syms.bit(2).set(2).col = estimated_col;
else
	target_syms.bit(2).set(1).col = 4;
	target_syms.bit(2).set(2).col = estimated_col;
end
 
% BIT 2
target_syms.bit(3).set(1).col = estimated_col;
target_syms.bit(3).set(2).col = estimated_col;
if estimated_row == 1 || estimated_row == 2
	target_syms.bit(3).set(1).row = 3;
	target_syms.bit(3).set(2).row = estimated_row;
else
	target_syms.bit(3).set(1).row = estimated_row;
	target_syms.bit(3).set(2).row = 2;
end


% BIT 3
target_syms.bit(4).set(1).col = estimated_col;
target_syms.bit(4).set(2).col = estimated_col;
if estimated_row == 1
	target_syms.bit(4).set(1).row = estimated_row;
	target_syms.bit(4).set(2).row = 2;
elseif estimated_row == 4
	target_syms.bit(4).set(1).row = estimated_row;
	target_syms.bit(4).set(2).row = 3;
elseif estimated_row == 2
	target_syms.bit(4).set(1).row = 1;
	target_syms.bit(4).set(2).row = estimated_row;
else
	target_syms.bit(4).set(1).row = 4;
	target_syms.bit(4).set(2).row = estimated_row;
end

end
