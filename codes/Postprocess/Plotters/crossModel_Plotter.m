clear;clc;close all

% CODE APPLIES LEFT PUPIL DIMATER MODEL TO RIGHT PUPIL DIAMETER DATA 
% (AND VICE VERSA) FOR DATA FROM THE MINOLTA SPECTROPHOMETER AND TOBII 
% PRO GLASSES 2

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-7:end), 'Plotters')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

load('objects/Workspaces/LPD_ensemble_MT.mat');
LPD_Mdl = Mdl;

load('objects/Workspaces/RPD_ensemble_MT.mat');

Mdl = LPD_Mdl;

save('objects/Workspaces/RPDwLMdl_ensemble_MT.mat');