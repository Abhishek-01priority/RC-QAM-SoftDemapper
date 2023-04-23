%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Proof of Concept for the solution
%%
%% Planned flow of script:
%% 	Plot Rotated 16-QAM constellation
%% 	Select a Rx Symbol(rI,rQ) and a reference symbol(aI,aQ)
%% 	Find the equation of line from (aI,aQ) to (rI,rQ)
%% 	Determine where this line intersect the rows line
%%
%% Author		: Abhishek K.M. (priority01abhishek@gmail.com)
%% Date of creation	: 16-04-2023
%% Date of modification : 22-04-2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
pkg load communications
clear all;
close all;
clc;

% I - Variables
dist	= 2;				% Distance between two symbols in same row/coloumn-Unormalized
pl_fg	= 1;				% Plot flag to plot everything or nothing
M	= 16; 				% Modulation order
alpha	= atan(1/sqrt(M)); 		% Angle to rotate the Modulation
d	= qammod(0:M-1,M); 		% unrotated QAM constellation
rI	= -0.9; rQ = -0.21; 		% Rx symbols
d	= d .* exp(1i * alpha);		% Rotated QAM
aI	= real(d(4)); aQ = imag(d(4));	% reference symbol for row 4 from top
ref_row = d(1:4); ref_col = d(4:4:16);	% reference symbols for rows and columns
x_row1	= real(d(1)):0.1:-real(d(1));	% First row from top
x_row2	= real(d(2)):0.1:-real(d(2));	% Second row from top	
x_row3	= real(d(3)):0.1:-real(d(3));	% Third row from top
x_row4	= real(d(4)):0.1:-real(d(4));	% Fourth row from top

% II - Equation of line from ref to rx symbol
slope = (rQ - aQ) / (rI - aI);
x = aI:0.1:-aI;
y = slope * (x - aI) + aQ; % equation1

% III - Equation of rows
y_row1 = tan(alpha) * (x_row1 - real(d(1))) + imag(d(1));
y_row2 = tan(alpha) * (x_row2 - real(d(2))) + imag(d(2));
y_row3 = tan(alpha) * (x_row3 - real(d(3))) + imag(d(3));
y_row4 = tan(alpha) * (x_row4 - real(d(4))) + imag(d(4));

% IV - Intersection of rows with equation1
m1 = tan(alpha);
m2 = slope;
intX_row = (m1 * real(ref_row) - m2 * aI + aQ - imag(ref_row)) / (m1 - m2);
intY_row = m1 * intX_row - m1 * real(ref_row) + imag(ref_row);
% Note --> d(1:4) are reference symbols for each row

% V - Comparision of quadrature components of intersection points
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

% VI - decision for row
estimated_row = row_min1_quadphase_loc;


% VII - Intersection of columns with equation1
m1 = -cot(alpha);
m2 = slope;
intX_col = (m1 * real(ref_col) - m2 * aI + aQ - imag(ref_col)) / (m1 - m2);
intY_col = m1 * intX_col - m1 * real(ref_col) + imag(ref_col);
% Note --> d(4:4:16) are reference symbols for each column

% VIII - Comparision of inphase components of intersection points
col_inphase_int = abs(intX_col - rI);temp_col_inphase_int=col_inphase_int;
[~,col_min1_inphase_loc] = min(col_inphase_int);
temp_col_inphase_int(col_min1_inphase_loc) = NaN;
[~,col_min2_inphase_loc] = min(temp_col_inphase_int);

% Below code is just used for debug and plot purpose
col_quadphase_int = abs(intY_col - rQ);temp_col_quadphase_int=col_quadphase_int;
[~,col_min1_quadphase_loc] = min(col_quadphase_int);
temp_row_quadphase_int(col_min1_quadphase_loc) = NaN;
[~,col_min2_quadphase_loc] = min(temp_row_quadphase_int);
% ---- debug code ends ------%

% IX - decision for column
estimated_col = col_min1_inphase_loc;

if pl_fg == 1
	figure(pl_fg);
	plot(d,'*','markersize',12)
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
	ylim([-4 4])
endif

grid minor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Notes
%% Reference symbol detector for each row is required
