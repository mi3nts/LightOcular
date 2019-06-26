clear;clc;close all

% CODE APPLIES AN ENSEMBLE METHOD TO ENVIORMENTAL/BIOMETRIC DATA FROM
% MINOLTA AND TOBII PRO GLASSES 2 - ILLUMINANCE MODELED BY
% PUPIL DIAMETER AND HEAD ROTATION

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% load all data in table form. Clean_All_MT_Table does not include any rows
% where the pupil diameters were measured as zero nor the columns
% corresponding to the error variables

load('Clean_All_MT_Table.mat');

% define vector of indicies for variables of interest
invarVec = [463 465 482:487];
outvarVec = 2;

% define table with variables of interest
Data = [Clean_All_MT_Table(:,invarVec) Clean_All_MT_Table(:,outvarVec)];

% define variable labels
VariableLabels = [...
    {'Left Pupil Diameter'}...
    {'Right Pupil Diameter'}...
    {'Gyroscope X'}...
    {'Gyroscope Y'}...
    {'Gyroscope Z'}...
    {'Accelerometer X'}...
    {'Accelerometer Y'}...
    {'Accelerometer Z'}...
    {'Illuminance'}];

% partition the data into a training and testing set
c = cvpartition(height(Data),'HoldOut',0.1);

% set up training data set
temp = (1:height(Data))';

train_rows = temp.*(c.training);
train_rows = train_rows(train_rows~=0);

Train = Data(train_rows,:);
InTrain = Train(:,1:8);
OutTrain = Train(:,9);

% set up testing data set
test_rows = temp.*(c.test);
test_rows = test_rows(test_rows~=0);

Test = Data(test_rows,:);
InTest = Test(:,1:8);
OutTest = Test(:,9);

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

% rename and save model
save('Workspaces/ILM_ensemble_MT.mat');