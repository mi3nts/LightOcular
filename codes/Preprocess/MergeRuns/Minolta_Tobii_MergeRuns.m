clear;clc;close all

% CODE CONCATENATE TIMETABLES FOR ALL DATA FOR ALL RUNS FOR MINOLTA AND
% TOBII PRO GLASSES 2 MEASUREMENTS

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-8:end), 'MergeRuns')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

load(['objects/' ...
'MinoltaTobii/Run1_MT_Timetable.mat']);

MT_Data_Timetable1 = MT_Data_Timetable;

load(['objects/' ...
'MinoltaTobii/Run2_MT_Timetable.mat']);

MT_Data_Timetable2 = MT_Data_Timetable;

load(['objects/' ...
'MinoltaTobii/Run3_MT_Timetable.mat']);

MT_All_Timetable = [MT_Data_Timetable1; MT_Data_Timetable2;...
    MT_Data_Timetable];

save(['objects/' ...
'MinoltaTobii/All_MT_Timetable.mat'], 'MT_All_Timetable');
