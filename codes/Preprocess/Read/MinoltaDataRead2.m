clear;clc;close all

% CODE TO READ DATA FROM MINOLTA CL-500A SPECTROPHOTOMETER IN THE FORM OF
% A .CSV FILE

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% -------------------------------------------------------------------------
% INSERT RAW FILE NAME BELOW:
filename = 'Run1.csv';
% -------------------------------------------------------------------------
% change directory to proper parent
str = pwd;
if strcmp(str(end-3:end), 'Read')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

% set display format to long
format long

% detect import options for .csv file
opts = detectImportOptions(strcat('raw/Minolta/', filename));

% read .csv file as a table
Tempdata_Table = readtable(strcat('raw/Minolta/', filename),opts);

% extract date variables from table and convert from char to datetime
% objects
Tempdata_Table.Date = datetime(Tempdata_Table.Date,'InputFormat','yyyy/MM/dd');
Tempdata_Table.Date = Tempdata_Table.Date + years(2000);

% concatenate date and time variables, then create a table of the datetime 
% objects 
Datetime_Table = array2table(Tempdata_Table.Date + Tempdata_Table.Time,...
    'VariableNames', {'Datetime'});

% concatenate datetime table with data table
MinoltaData_Table = [Datetime_Table Tempdata_Table(:,3:454)];
MinoltaData_Table = unique(MinoltaData_Table);

% convert table to timetable
MinoltaData_Timetable = table2timetable(MinoltaData_Table);
MinoltaData_Timetable = unique(MinoltaData_Timetable);

% save timetable to file
save('objects/Minolta/Run1_Minolta_Timetable.mat','MinoltaData_Timetable');