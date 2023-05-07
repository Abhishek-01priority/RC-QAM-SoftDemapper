A top wrapper	--> Run entire Dr. Peng Xue's research
				--> Run improvements
				--> General area to give configurations

Dr. Peng Xue's research implementation

Module specific codes	--> Detecting reference symbols
						--> Identifying coloumn and row of Rx symbol
						--> Determining which rows and coloumns are required for euclidan distance calculation
						--> LLR calculation algo 1
						--> LLR calculation algo 2
						--> BER calculation

Notes 
1. 15dB SNR and below, row and column estimation is going wrong
2. Lines are not straight for that SNR and therefore intersection points are wrongly found
3. Either do soft decision to find which row/column symbol belongs or at some area for each row/column 
