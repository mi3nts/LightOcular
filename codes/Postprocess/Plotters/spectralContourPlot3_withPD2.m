clear;clc;close all

% CODE PLOTS CONTOUR DIAGRAM OF MINOLTA SPECTRAL DATA WHERE THE SPECTRAL
% IRRADIANCE IS NORMALIZED WITHIN EACH TRIAL

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

format long

% change directory to proper parent
str = pwd;
if strcmp(str(end-7:end), 'Plotters')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

% load desired worspace
load('objects/Tables/All_MT_Table.mat');

% add spectrum labels
spectrumVec = 360:780; 

% find row numbers that correspond to each day
iwant1 = find(day(MT_All_Table.Datetime)==26);
iwant2 = find(day(MT_All_Table.Datetime)==29);
iwant3 = find(day(MT_All_Table.Datetime)==2);

iwantZerosL = find((MT_All_Table.PupilDiameter_LeftPupilDiameter_Timetable)==0);
iwantZerosR = find((MT_All_Table.PupilDiameter_RightPupilDiameter_Timetable)==0);

MT_All_Table.PupilDiameter_LeftPupilDiameter_Timetable(iwantZerosL,:) = ...
    NaN;
MT_All_Table.PupilDiameter_RightPupilDiameter_Timetable(iwantZerosR,:) = ...
    NaN;

Data1  = retime(table2timetable(MT_All_Table(iwant1,[1 2 31:451 466 469])),...
    'regular',@nanmean,'TimeStep',seconds(3));
Data2  = retime(table2timetable(MT_All_Table(iwant2,[1 2 31:451 466 469])),...
    'regular',@nanmean,'TimeStep',seconds(3));
Data3  = retime(table2timetable(MT_All_Table(iwant3,[1 2 31:451 466 469])),...
    'regular',@nanmean,'TimeStep',seconds(3));


Data1 = Data1.Variables;
Data2 = Data2.Variables;
Data3 = Data3.Variables;

Z1 = Data1(:,2:422)./max(max(Data1(:,2:422)));
Z2 = Data2(:,2:422)./max(max(Data2(:,2:422)));
Z3 = Data3(:,2:422)./max(max(Data3(:,2:422)));


LPD1 = Data1(:,end-1);
RPD1 = Data1(:,end);
LPD2 = Data2(:,end-1);
RPD2 = Data2(:,end);
LPD3 = Data3(:,end-1);
RPD3 = Data3(:,end);

r3=size(Data3);

t1 = 0.05.*(1:length(Data1));
t2 = 0.05.*(1:length(Data2));
t3 = 0.05.*(1:r3(1));

% create contour plots for each run
ifig = 1;
for j=1:3
    fig = figure(ifig);
    fig.Position = [0 0 1920 1080];
    subplot(4,1,[1,2,3]);
    eval(strcat("contourf(t", string(j),",spectrumVec,(Z", string(j),...
        "'),50, 'LineStyle', 'None')"));
    c = colorbar;
    colormap(jet)
    c.Location = 'southoutside';
    c.Label.String = 'Normalized Spectral Irradiance';
    c.Label.FontSize = 12;
    hold on
    eval(strcat("plot(t", string(j),",(t",string(j),"./t",string(j),...
        ")*528,'Color','#56ff00','LineWidth', 2);"));
    eval(strcat("plot(t", string(j),",(t",string(j),"./t",string(j),...
        ")*563,'Color','#ccff00','LineWidth', 2);"));
    eval(strcat("plot(t", string(j),",(t",string(j),"./t",string(j),...
        ")*567,'Color','#b5c951','LineWidth', 2);"));
    eval(strcat("plot(t", string(j),",(t",string(j),"./t",string(j),...
        ")*776,'Color','#6a0000','LineWidth', 2);"));
%     legend('Illuminance Spectral Data', '528 nm', '563 nm','776 nm',...
%         'Location', 'NorthWest');
    

    legend('Normalized Spectral Irradiance', '528 nm', '563 nm','567 nm','776 nm',...
        'Location', 'NorthWest');
    ax = gca;
    eval(strcat("ax.Title.String = 'Spectral and Pupillometric Measurments for Walk ",...
        string(j), "';"));
    ax.Title.FontSize = 24;
    ax.XTickLabel = [];
    eval(strcat('ax.XLim = [0 t',string(j),'(end)];'));
    ax.YLabel.String = 'Wavelength (nm)';
    ax.YLabel.FontSize = 16;
    fig.CurrentAxes.FontSize = 14;
    fig.CurrentAxes.TitleFontSizeMultiplier = 1.6;
 
    hold off
    
    subplot(4,1,4);
%     eval(strcat('plot(MT_All_Table.Datetime(iwant',string(i+3),'),LPD',...
%         string(i),", 'Color', '#F7F700', 'Linewidth', 1)"));
%     hold on
%     eval(strcat('plot(MT_All_Table.Datetime(iwant',string(i+3),'),RPD',...
%         string(i),", 'Color', '#08F700', 'Linewidth', 1)"));
    eval(strcat('plot(t',string(j),',LPD',...
        string(j),", 'Color', '#F7F700', 'Linewidth', 1)"));
    hold on
    eval(strcat('plot(t',string(j),',RPD',...
        string(j),", 'Color', '#08F700', 'Linewidth', 1)"));
    
    ax = gca;
    eval(strcat('ax.XLim = [0 t',string(j),'(end)];'));
    ax.XLabel.String = 'Time From First Record (minutes)';
    ax.XLabel.FontSize = 16;
    ax.YLabel.String = 'Pupil Diameter (mm)';
    ax.YLabel.FontSize = 16;
    legend('Left', 'Right');
    fig.CurrentAxes.FontSize = 14;
    ax.Title.FontSize = 24;
    
    eval(strcat("print('Plots/spectralPlots/spectrum3_2wPDRun", string(j),"','-dpng')"));
    ifig = ifig + 1;
end