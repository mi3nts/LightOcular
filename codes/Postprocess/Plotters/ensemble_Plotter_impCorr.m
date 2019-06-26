clear;clc;close all

% CODE PLOTS IMPORTANCE RANKING, ERROR HISTOGRAM, AND SCATTER FOR COMPACT
% ENSEMBLE TREE MODEL

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-7:end), 'Plotters')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

% load desired worspace
load('objects/Workspaces/LPD_ensemble_MT.mat');

% apply compact model to training set
Out_Train = predict(Mdl,InTrain);

% apply compact model to testing set
Out_Test = predict(Mdl,InTest);

% convert Out Tables to Arrays
OutTrain = table2array(OutTrain);
OutTest = table2array(OutTest);

% calculate mean squared error for training set
mseTrain = mean((Out_Train-OutTrain).^2);

% calculate mean squared error for testing set
mseTest = mean((Out_Test-OutTest).^2);

% calculate correlation coefficent for training set
cc_train = corrcoef(Out_Train,OutTrain);
r_train = cc_train(1,2);
r2_train = r_train^2;

% calculate correlation coefficent for testing set
cc_test = corrcoef(Out_Test,OutTest);
r_test = cc_test(1,2);
r2_test = r_test^2;

% compute importance rankings 
imp=predictorImportance(Mdl);

% sort importance in descending order
[sorted_imp,isorted_imp] = sort(imp,'descend');

topPredictor = VariableLabels{isorted_imp(1)};

pdSamp_est = datasample(Out_Train, round(0.01*length(OutTrain)));
pdSamp = datasample(OutTrain, round(0.01*length(OutTrain)));
tpSamp = datasample(table2array(InTrain(:,isorted_imp(1))), round(0.01*length(OutTrain)));


loglog(pdSamp_est,tpSamp,'go');
hold on
loglog(pdSamp,tpSamp,'bo');

% % plot training/testing actual vs model estimation and 1 to 1
% figure(3)
% plot(OutTest,OutTest,'k', 'LineWidth', 2)
% hold on
% scatter(Out_Train,OutTrain,'go')
% hold on
% scatter(Out_Test,OutTest,'r+')
% legend("1:1", strcat("Training r^2 = ",string(r2_train)), ...
%     strcat("Testing r^2 = ",string(r2_test)),...
%     'FontSize', 16,'Location', 'southeast');
% title([VariableLabels(end) ' Scatter Plot (Ensemble Method)'], 'FontSize',...
%     16)
% xlabel(['Estimated ' VariableLabels(end)], 'FontSize', 16)
% ylabel(['True ' VariableLabels(end)], 'FontSize', 16)
% hold off
% 
% % save plot to file
% print(strcat("Plots/ScatterPlots/", VariableLabels(end), "_Ensemble_Scatter"),'-dpng')