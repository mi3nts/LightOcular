clear;clc;close all

% CODE TO CONVERT LEFT AND RIGHT PUPIL DIAMETER VALUES IN CLEAN ALL MT DATA
% TABLE TO A SINGLE AVERAGE PUPIL DIAMETER

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-17:end), 'VariableGeneration')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

% load data table
load(['objects/' ...
'MinoltaTobii/Clean_All_MT_Table.mat']);

% rename table
Data = Clean_All_MT_Table;

% remove datetime variable
Data.Datetime = [];

% create arrays of pupil diameters 
LPD = Data.PupilDiameter_LeftPupilDiameter_Timetable;
RPD = Data.PupilDiameter_RightPupilDiameter_Timetable;

% remove pupil diameters from data table
Data.PupilDiameter_LeftPupilDiameter_Timetable = [];
Data.PupilDiameter_RightPupilDiameter_Timetable = [];

% create array and table of average pupil diameter
PDD = abs(LPD - RPD);
PDD_Table = array2table(PDD,'VariableNames',{'PupilDiameterDifference'});

% append Data to include average pupil diameter
Data = [Data PDD_Table];

% rename data table
Clean_PDD_MT_Table = Data;

% save table to file
save(['objects/' ...
'MinoltaTobii/Clean_PDD_MT_Table.mat'],'Clean_PDD_MT_Table');