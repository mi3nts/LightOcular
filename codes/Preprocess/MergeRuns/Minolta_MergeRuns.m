clear;clc;close all

% CODE CONCATENATE TIMETABLES FOR MINOLTA DATA FOR ALL RUNS 

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-8:end), 'MergeRuns')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

load('objects/Minolta/Run1_Minolta_Timetable.mat');

MinoltaData_Timetable1 = MinoltaData_Timetable;

load('objects/Minolta/Run2_Minolta_2019_3_29_8_Timetable.mat');

MinoltaData_Timetable2 = MinoltaData_Timetable;

load('objects/Minolta/Run3_Minolta_2019_4_2_15_Minolta_Timetable.mat');

MinoltaData_Timetable31 = MinoltaData_Timetable;

load('objects/Minolta/Run3_Minolta_2019_4_2_16_Minolta_Timetable.mat');

MinoltaData_Timetable32 = MinoltaData_Timetable;

Minolta_All_Timetable = [MinoltaData_Timetable1; MinoltaData_Timetable2;...
    MinoltaData_Timetable31; MinoltaData_Timetable32];

save('objects/Minolta/Minolta_All_Timetable.mat', 'Minolta_All_Timetable');