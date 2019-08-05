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

load('objects/Workspaces/RPDwLMdl_ensemble_MT.mat');

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

% calulate error for testing set
e = (Out_Test-OutTest);

% plot error histogram
figure(1)
ploterrhist(e)
title([VariableLabels(end) ' Error Histogram (Opposite Eye Model)'],...
    'Fontsize', 16);
ax = gca;
ax.OuterPosition = [0 0.1 1 0.9];
ax.FontSize = 16;
hold off

% save histogram
print(strcat("codes/Postprocess/Plotters/Plots/errorHistogram/",VariableLabels(end),"_Ensemble_oppMdl_ErrHist"),'-dpng')

% compute importance rankings 
imp=predictorImportance(Mdl);

% sort importance in descending order
[sorted_imp,isorted_imp] = sort(imp,'descend');

% create bar graph of importance rankings
figure(2)
n_top_bars = 20;
barh(imp(isorted_imp(1:n_top_bars)));
hold on;grid on;
    if length(isorted_imp)>=5
        barh(imp(isorted_imp(1:5)),'y');
    else
        barh(imp(isorted_imp),'y');
    end
    if length(isorted_imp)>=3
        barh(imp(isorted_imp(1:3)),'r');
    else
        barh(imp(isorted_imp(1:n_top_bars)),'r');
    end
title([VariableLabels(end) ' Predictor Importance Estimates (Opposite Eye Model)'],...
    'Fontsize', 16);
xlabel('Estimated Importance', 'Fontsize', 16);
ylabel('Predictors', 'Fontsize', 16);
set(gca,'FontSize',16); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
ax = gca;ax.YDir='reverse';ax.XScale = 'log';
xl=xlim;
xlim([xl(1) xl(2)*2.75]);
ylim([.25 n_top_bars+.75])

% label the variables
  for i=1:n_top_bars
    text(...
        1.05*imp(isorted_imp(i)),i,...
        strrep(VariableLabels{isorted_imp(i)},'_',''),...
        'FontSize',16 ...
    )
  end
  hold off
% save graph as png
print(strcat("codes/Postprocess/Plotters/Plots/importanceRanking/", VariableLabels(end),"_Ensemble_oppMdl_ImpRank_T20"),'-dpng')

% plot training/testing actual vs model estimation and 1 to 1
figure(3)
plot(OutTest,OutTest,'k', 'LineWidth', 2)
hold on
scatter(Out_Train,OutTrain,'go')
hold on
scatter(Out_Test,OutTest,'r+')
legend("1:1", strcat("Training r^2 = ",string(r2_train)), ...
    strcat("Testing r^2 = ",string(r2_test)),...
    'FontSize', 16,'Location', 'southeast');
title([VariableLabels(end) ' Scatter Plot (Opposite Eye Model)'], 'FontSize',...
    16)
xlabel(['Estimated ' VariableLabels(end)], 'FontSize', 16)
ylabel(['True ' VariableLabels(end)], 'FontSize', 16)
hold off

% save plot to file
print(strcat("codes/Postprocess/Plotters/Plots/scatterPlots/", VariableLabels(end), "_Ensemble_oppMdl_Scatter"),'-dpng')
