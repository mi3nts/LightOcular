clear;clc;close all

% CODE RUNS ALL ENSEMBLE CODES IN SEQUENCE

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-7:end), 'Analysis')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-1)))))
end

cd codes/Analysis

A930_LPD_ensemble_MT;
A930_RPD_ensemble_MT;
A930_APD_ensemble_MT;
A930_PDD_ensemble_MT;
A930_ILM_ensemble_MT;