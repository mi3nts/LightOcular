clear;clc;close all

% CODE PLOTS CONTOUR DIAGRAM OF MINOLTA SPECTRAL DATA WHERE THE SPECTRAL
% Illuminance IS Relative WITHIN EACH TRIAL

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% change directory to proper parent
str = pwd;
if strcmp(str(end-7:end), 'Plotters')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

format long

% load data table
load(['objects/' ...
'Timetables/Minolta_All_Timetable.mat']);

% extract data used in analysis
Data = Minolta_All_Timetable(564:end,30:450); 

% add spectrum labels
spectrumVec = 360:780; 
VariableLabels = strcat(string(spectrumVec), ' nm');

% find row numbers that correspond to each day
iwant1 = find(day(Data.Properties.RowTimes)==26);
iwant2 = find(day(Data.Properties.RowTimes)==29);
iwant3 = find(day(Data.Properties.RowTimes)==2);

% define time vector in minutes for each run
t = seconds(Data.Datetime - Data.Datetime(1))./60;
t1 = t(iwant1);
t2 = t(iwant2);
t3 = t(iwant3);

t2 = t2 - t2(1);
t3 = t3 - t3(1);

% convert Illuminance Spectral Data data table to Relative values in an array
SpectrumTable = timetable2table(Data);
Spectrum = table2array(SpectrumTable(:,2:end));
Spectrum_Relative = Spectrum./max(max(Spectrum));

% create matrices of wavelength intensities for each run
Z1 = Spectrum(iwant1,:);
Z2 = Spectrum(iwant2,:);
Z3 = Spectrum(iwant3,:);

Z1 = Z1./max(max(Z1));
Z2 = Z2./max(max(Z2));
Z3 = Z3./max(max(Z3));


% create contour plots for each run
ifig = 1;
for i=1:3
    figure(ifig)
    eval(strcat("contourf(t", string(i),",spectrumVec,Z", string(i),...
        "',50, 'LineStyle', 'None')"));
    c = colorbar;
    c.Label.String = 'Relative Spectral Illuminance';
    c.Label.FontSize = 12;
    hold on
    eval(strcat("plot(t", string(i),",(t",string(i),"./t",string(i),...
        ")*528,'Color','#56ff00','LineWidth', 2);"));
    eval(strcat("plot(t", string(i),",(t",string(i),"./t",string(i),...
        ")*563,'Color','#ccff00','LineWidth', 2);"));
    eval(strcat("plot(t", string(i),",(t",string(i),"./t",string(i),...
        ")*567,'Color','#b5c951','LineWidth', 2);"));
    eval(strcat("plot(t", string(i),",(t",string(i),"./t",string(i),...
        ")*776,'Color','#6a0000','LineWidth', 2);"));
%     legend('Illuminance Spectral Data', '528 nm', '563 nm','776 nm',...
%         'Location', 'NorthWest');
    legend('Relative Spectral Illuminance', '528 nm', '563 nm','567 nm','776 nm',...
        'Location', 'NorthWest');
    ax = gca;
    eval(strcat("ax.Title.String = 'Spectral Measurments for Trial ",...
        string(i), "';"));
    ax.Title.FontSize = 16;
    ax.XLabel.String = 'Time From First Record (minutes)';
    ax.XLabel.FontSize = 16;
    ax.YLabel.String = 'Wavelength (nm)';
    ax.YLabel.FontSize = 16;
    hold off
    
    eval(strcat("print('Postprocess/Plotters/Plots/Spectral/spectrum3Run",...
        string(i),"','-dpng')"));
    ifig = ifig + 1;
end
