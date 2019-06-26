clear;clc;close all

% CODE TO MERGE AND SYNC TIMETABLES OF MINOLTA AND TOBII PRO GLASSES 2
% DATA

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-11:end), 'MergeAndSync')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

% load timetables
load('objects/Minolta/Run3_Minolta_2019_4_2_15_Minolta_Timetable.mat');

% create temp timetable to store data
MinoltaData15_Timetable = MinoltaData_Timetable;

load('objects/Minolta/Run3_Minolta_2019_4_2_16_Minolta_Timetable.mat');

% concatenate timetables across hour
MinoltaData_Timetable = [MinoltaData15_Timetable; MinoltaData_Timetable];

load('objects/Tobii/Run3_Tobii_Timetable.mat');

% correct Tobii time discrepency if necessary
TobiiData_Timetable.Timestamp = TobiiData_Timetable.Timestamp - hours(5);

% Resample data to coincide at 1/100 second timesteps
dt = seconds(1/100);
MinoltaData_Timetable = retime(MinoltaData_Timetable,'regular'...
    ,'linear','SampleRate', 100);

TobiiData_Timetable = retime(TobiiData_Timetable,'regular'...
    ,'next','TimeStep', dt);

% synchronize timetables and remove NaNs
MT_Data_Timetable = synchronize(MinoltaData_Timetable,...
    TobiiData_Timetable, 'intersection');
MT_Data_Timetable = rmmissing(MT_Data_Timetable);

% save timetable object
save('objects/MinoltaTobii/Run3_MT_Timetable.mat', 'MT_Data_Timetable');