clear;clc;close all

% CODE APPLIES ENSEMLBLE METHOD TO ENVIORMENTAL/BIOMETRIC DATA FROM
% MINOLTA AND TOBII PRO GLASSES 2 - LEFT PUPIL DIAMETER MODELED BY
% LIGHT INTENSITY, SPECTRUM, AND HEAD ROTATION

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% load all data in table form. Clean_All_MT_Table does not include any rows
% where the pupil diameters were measured as zero nor the columns
% corresponding to the error variables

% change directory to proper parent
str = pwd;
if strcmp(str(end-7:end), 'Analysis')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-1)))))
end

% load all data in table form
load('objects/MinoltaTobii/Clean_APD_MT_Table.mat');

% define vector of indicies for variables of interest
invarVec = [2 31:451 482:487];
outvarVec = 463;

% define table with variables of interest
Data = [Clean_All_MT_Table(:,invarVec) Clean_All_MT_Table(:,outvarVec)];

% define variable labels
VariableLabels = {'Illuminance'};   % define first label

% add spectrum labels
spectrumVec = 360:780; 
VariableLabels = [VariableLabels strcat(string(spectrumVec), ' nm')];

% add biometric labels
VariableLabels = [VariableLabels ...
    {'Gyroscope X'}...
    {'Gyroscope Y'}...
    {'Gyroscope Z'}...
    {'Accelerometer X'}...
    {'Accelerometer Y'}...
    {'Accelerometer Z'}...
    {'Left Pupil Diameter'}];

% partition the data into a training and testing set
c = cvpartition(height(Data),'HoldOut',0.1);

% set up training data set
temp = (1:height(Data))';

train_rows = temp.*(c.training);
train_rows = train_rows(train_rows~=0);

Train = Data(train_rows,:);
InTrain = Train(:,1:428);
OutTrain = Train(:,429);

% set up testing data set
test_rows = temp.*(c.test);
test_rows = test_rows(test_rows~=0);

Test = Data(test_rows,:);
InTest = Test(:,1:428);
OutTest = Test(:,429);

% set up parallel processing
mypool = parpool(16);

% create  model
Mdl = fitrensemble(table2array(InTrain), table2array(OutTrain),...
    'PredictorNames', Data.Properties.VariableNames(1:end-1),...
    'ResponseName', Data.Properties.VariableNames{end},...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',...
    struct(...
    'AcquisitionFunctionName','expected-improvement-plus',...
    'MaxObjectiveEvaluations',30,...
    'UseParallel',true)...
    );

% delete parallel pool
delete(mypool);

% reduce size of model
whos Mdl
Mdl=compact(Mdl);
whos Mdl

% save Workspace
save('objects/Workspaces/LPD_ensemble_MT.mat');