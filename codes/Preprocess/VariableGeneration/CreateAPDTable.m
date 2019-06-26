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
rename(Clean_All_MT_Table, 'Data');

% remove datetime variable
Data.Datetime = [];

% create arrays of pupil diameters 
LPD = Data.PupilDiameter_LeftPupilDiameter_Timetable;
RPD = Data.PupilDiameter_RightPupilDiameter_Timetable;

% remove pupil diameters from data table
Data.PupilDiameter_LeftPupilDiameter_Timetable = [];
Data.PupilDiameter_RightPupilDiameter_Timetable = [];

% create array and table of average pupil diameter
APD = (LPD + RPD)./2;
APD_Table = array2table(APD,'VariableNames',{'AveragePupilDiameter'});

% append Data to include average pupil diameter
Data = [Data APD_Table];

% rename data table
rename(Data,'Clean_APD_MT_Table');

% save table to file
save(['objects/' ...
'MinoltaTobii/Clean_APD_MT_Table.mat'],'Clean_APD_MT_Table');