%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Proof of Concept code used with TB
%% Brief of variables	:
%% 1) intX_row, intY_row     -> Points of intersection b/w
%%			    	ref-rx line and different rows
%%
%% 2) intX_col, intY_col     -> Points of intersection b/w
%% 			    	ref-rx line and different rows
%%
%% 3) row_quadrature_int     -> Absolute difference b/w intY_row and
%%			    	quadrature component of rx symbol, used for
%%			    	estimating the row 
%%
%% 4) row_min1_quadphase_loc,
%%    row_min2_quadphase_loc -> 1st and 2nd min index of row_quadrature_int
%%
%% 5) col_inphase_int        -> Absolute difference b/w intX_col and
%%			    	inphase component of rx symbol, used for
%%			    	estimating the column 
%% 6) col_min1_inphase_loc,
%%    col_min2_inphase_loc   ->	1st and 2nd min index of col_inphase_int
%% 
%% Input arguments	: none
%% Output arguments	: estimated_row, estimated_col, dv (intermediate output)
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 23-04-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [estimated_row, estimated_col, dv] = proof_of_concept()
global pl_fg
global alpha
global d;
global rx;
global rI
global rQ
global ref_row
global ref_col

aI = real(ref_row(4)); aQ = imag(ref_row(4));
dv = struct();
% I - Equation of line from ref to rx symbol
if rI != aI
	slope = (rQ - aQ) / (rI - aI);
	x = aI:0.1:4;
	y = slope * (x - aI) + aQ; % equation1
	
	% II - Intersection of rows with equation1
	m1 = tan(alpha);
	m2 = slope;
	intX_row = (m1 * real(ref_row) - m2 * aI + aQ - imag(ref_row)) / (m1 - m2);
	intY_row = m1 * intX_row - m1 * real(ref_row) + imag(ref_row);
	
	% III - Comparision of quadrature components of intersection points
	% below code is just used for debug and plot purpose
	row_inphase_int = abs(intX_row - rI);temp_row_inphase_int=row_inphase_int;
	[~,row_min1_inphase_loc] = min(row_inphase_int);
	temp_row_inphase_int(row_min1_inphase_loc) = NaN;
	[~,row_min2_inphase_loc] = min(temp_row_inphase_int);
	%-------debug code ends------%
	
	row_quadphase_int = abs(intY_row - rQ);temp_row_quadphase_int=row_quadphase_int;
	[~,row_min1_quadphase_loc] = min(row_quadphase_int);
	temp_row_quadphase_int(row_min1_quadphase_loc) = NaN;
	[~,row_min2_quadphase_loc] = min(temp_row_quadphase_int);
	
	% IV - decision for row
	estimated_row = row_min1_quadphase_loc;
	
	% V - Intersection of columns with equation1
	m1 = -cot(alpha);
	m2 = slope;
	intX_col = (m1 * real(ref_col) - m2 * aI + aQ - imag(ref_col)) / (m1 - m2);
	intY_col = m1 * intX_col - m1 * real(ref_col) + imag(ref_col);
	% Note --> d(4:4:16) are reference symbols for each column
	
	% V - Comparision of inphase components of intersection points
	col_inphase_int = abs(intX_col - rI);temp_col_inphase_int=col_inphase_int;
	[~,col_min1_inphase_loc] = min(col_inphase_int);
	temp_col_inphase_int(col_min1_inphase_loc) = NaN;
	[~,col_min2_inphase_loc] = min(temp_col_inphase_int);
	
	% Below code is just used for debug and plot purpose
	col_quadphase_int = abs(intY_col - rQ);temp_col_quadphase_int=col_quadphase_int;
	[~,col_min1_quadphase_loc] = min(col_quadphase_int);
	temp_col_quadphase_int(col_min1_quadphase_loc) = NaN;
	[~,col_min2_quadphase_loc] = min(temp_col_quadphase_int);
	% ---- debug code ends ------%
	
	% VI - decision for column
	estimated_col = col_min1_inphase_loc;
else
	% IV - decision for row
	estimated_row = 4;
	% VI - decision for column
	estimated_col = 1;
endif
	

if pl_fg == 1 && rI != aI
	figure(pl_fg);
	plot(rx,'*','markersize',12)
	hold on; plot(rI,rQ,'^','MarkerFaceColor','r')
	hold on; plot(x,y,'m-')
	hold on; plot(intX_row, intY_row,'^','MarkerFaceColor','g')
	hold on; plot(intX_col, intY_col,'^','MarkerFaceColor','k')
	hold on; plot([intX_row(row_min1_inphase_loc) -4],[intY_row(row_min1_quadphase_loc) intY_row(row_min1_quadphase_loc)],'g-')
	hold on; plot([intX_row(row_min2_inphase_loc) -4],[intY_row(row_min2_quadphase_loc) intY_row(row_min2_quadphase_loc)],'g-')
	hold on; plot([intX_col(col_min1_inphase_loc) intX_col(col_min1_inphase_loc)],[intY_col(col_min1_quadphase_loc) -4],'k-')
	hold on; plot([intX_col(col_min2_inphase_loc) intX_col(col_min2_inphase_loc)],[intY_col(col_min2_quadphase_loc) -4],'k-')
	hold on; plot([rI rI],[rQ -4],'r-')
	hold on; plot([rI -4],[rQ rQ],'r-')
	legend("R-16-QAM","Rx Point","Line from ref sym to rxsym","PoI b/w rows and line","PoI b/w cols and line")
	ylim([min(imag(rx))-1 max(imag(rx))+1])
	xlim([min(real(rx))-1 max(real(rx))+1])
	grid minor
endif

if rI != aI
	dv.slope			= slope;
	dv.intX_row			= intX_row;
	dv.intY_row			= intY_row;
	dv.intX_col			= intX_col;
	dv.intY_col			= intY_col;
	dv.row_quadphase_int		= row_quadphase_int;
	dv.row_min1_quadphase_loc	= row_min1_quadphase_loc;
	dv.row_min2_quadphase_loc       = row_min2_quadphase_loc;
	dv.col_inphase_int              = col_inphase_int;
	dv.col_min1_inphase_loc         = col_min1_inphase_loc;
	dv.col_min2_quadphase_loc       = col_min2_quadphase_loc;
endif
dv.estimated_row                = estimated_row;
dv.estimated_col                = estimated_col;

%keyboard
%if pl_fg == 1
%	clf(1);
%endif
endfunction







