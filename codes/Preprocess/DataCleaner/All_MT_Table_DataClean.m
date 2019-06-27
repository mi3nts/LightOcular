clear;clc;close all

% CODE CLEANS ENVIORMENTAL/BIOMETRIC DATA FROM MINOLTA AND TOBII PRO 
% GLASSES 2 BY REMOVING ERROR VARIABLES AND RECORDS

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-10:end), 'DataCleaner')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

% load all data in timetable form
load(['objects/' ...
'MinoltaTobii/MT_All_Timetable.mat']);

% convert timetable to table
MT_All_Table = timetable2table(MT_All_Timetable);

% remove datetime variable
Data = MT_All_Table;
disp(height(Data))

% define vector with elements of error variables
errVec = [454; 459; 464; 467; 470; 475; 480; 485; 493; 497];

% define cell array with error variable names
errNames = Data.Properties.VariableNames(errVec);

% find where left pupil diameter is 0 and remove those rows
iLPD_zero = find(Data.PupilDiameter_LeftPupilDiameter_Timetable==0);
Data(iLPD_zero,:) = [];

disp(height(Data))

% find where right pupil diameter is 0 and remove those rows
iRPD_zero = find(Data.PupilDiameter_RightPupilDiameter_Timetable==0);
Data(iRPD_zero,:) = [];

disp(height(Data))

% find where error are not 0 and remove those rows
for i = 1:10
    itemp_nonzero = find(table2array(Data(:,errVec(i))));
    Data(itemp_nonzero,:) = [];
    break
end

disp(height(Data))

% remove error variables
Data(:,errNames) = [];

% rename data table
Clean_All_MT_Table = Data;

% save data table to file
save(['objects/' ...
'MinoltaTobii/Clean_All_MT_Table.mat'],'Clean_All_MT_Table');