clear;clc;close all

% CODE CREATES WORKSPACE WITH BOTH THE LEFT AND RIGHT PUPIL DIAMETER MODELS
% TO BE USED IN THE CODE: ensemble_oppMdl_Plotter.m

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