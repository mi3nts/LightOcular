clear;clc;close all

% CODE TO READ DATA FROM LIVEDATA.JSON FILE FOR TOBII PRO GLASSES 2

% CODE AUTHORED BY: SHAWHIN TALEBI
% THE UNIVERSITY OF TEXAS AT DALLAS
% MULTI-INTEGRATED REMOTE SENSING AND SIMULATION (MINTS)

% -------------------------------------------------------------------------
% INSERT RUN NUMBER BELOW:
Run = 'test';
% -------------------------------------------------------------------------
% change directory to proper parent
str = pwd;
if strcmp(str(end-3:end), 'Read')
    idcs = strfind(pwd,filesep);
    eval(strcat("cd ", (str(1:idcs(end-2)))))
end

% set display format to long
format long

% read segment .json file
% string1 = fileread('Data/segment.json'); % test data
string1 = fileread(strcat('raw/Tobii/',Run,'_segment.json'));

% decode segment.json file
string_decoded = jsondecode(string1);

% get date and time info and create duration objects
start_datetime = string_decoded.seg_t_start;
start_date = datetime(start_datetime(1:10), 'InputFormat', 'yyyy-MM-dd');
start_time = duration(start_datetime(12:19),'format','hh:mm:ss.SSSS');

stop_datetime = string_decoded.seg_t_stop;
stop_date = datetime(stop_datetime(1:10), 'InputFormat', 'yyyy-MM-dd');
stop_time = duration(stop_datetime(12:19),'format','hh:mm:ss.SSSS');

% define duration object for elapsed time
elapsed_time = (stop_date+stop_time) - (start_date+start_time);

% open livedata file
% file = fopen('Data/livedata.json'); % test data
file = fopen(strcat('raw/Tobii/',Run,'_livedata.json'));

% DEFINE VARIABLE NAMES FOR TABLES BASED ON EVERY POSSIBLE LINE TYPE

% variable names of pupil center tables (6 vars) (5 fields)
NamesPC = {'Timestamp', 'Error', 'GazeIndex', 'PupilCenterX',...
    'PupilCenterY', 'PupilCenterZ'};

% variable names of pupil diameter tables (4 vars) (5 fields)
NamesPD = {'Timestamp', 'Error', 'GazeIndex', 'PupilDiameter'};

% variable names of gaze direction tables (6 vars) (5 fields)
NamesGD = {'Timestamp', 'Error', 'GazeIndex', 'GazeDirectionX', ...
    'GazeDirectionY', 'GazeDirectionZ'};

% variable names of gaze position table (6 vars) (5 fields)
NamesGP = {'Timestamp', 'Error', 'GazeIndex', 'Latency', 'GazePositionX', ...
    'GazePositionY'};

% variable names of API-sync package table (5 vars) (5 fields)
NamesAPI = {'Timestamp', 'Error', 'EventTimeStamp', 'Type', 'Tag'}; 

% variable names of 3D gaze position table (6 vars) (4 fields)
NamesGP3D = {'Timestamp', 'Error', 'GazeIndex', 'GazePosition3DX',...
    'GazePosition3DY', 'GazePosition3DZ'};

% variable names of sync port signal package table (4 vars) (4 fields)
NamesSyncPort = {'Timestamp', 'Error', 'Direction', 'Signal'};

% variable names of presentation timestamp sync package table (4 vars) (4 fields)
NamesPTS = {'Timestamp', 'PresentationTimestamp', 'PipelineVersion','Error'};

% variable names of gyroscope table (5 vars) (3 fields)
NamesGyro = {'Timestamp', 'GyroscopeX', 'GyroscopeY', 'GyroscopeZ', 'Error'};

% variable names of accelerometer table (5 vars) (3 fields)
NamesAccel = {'Timestamp', 'AccelerometerX', 'AccelerometerY',...
    'AccelerometerZ', 'Error'};

% variable names of video timestamp sync package table (3 vars) (3 fields)
NamesVTS = {'Timestamp', 'VideoTimestamp','Error'};

% variable names of eye camera video timestamp sync package table (3 vars) (3 fields)
NamesEVTS = {'Timestamp', 'Error', 'EyeVideoTimestamp'};


initial3 = {NaN NaN NaN};
initial4 = {NaN NaN NaN NaN};
initial5 = {NaN NaN NaN NaN NaN};
initial6 = {NaN NaN NaN NaN NaN NaN};

% TobiiTable = cell2table(initial,'VariableNames',Names);

% INTIALIZE TABLES
LeftPupilCenter_Table = cell2table(initial6, 'VariableNames', NamesPC);
RightPupilCenter_Table = cell2table(initial6, 'VariableNames', NamesPC);
LeftPupilDiameter_Table = cell2table(initial4, 'VariableNames', NamesPD);
RightPupilDiameter_Table = cell2table(initial4, 'VariableNames', NamesPD);
LeftGazeDirection_Table = cell2table(initial6, 'VariableNames', NamesGD);
RightGazeDirection_Table = cell2table(initial6, 'VariableNames', NamesGD);
GazePosition_Table = cell2table(initial6, 'VariableNames', NamesGP);
GazePosition3D_Table = cell2table(initial6, 'VariableNames', NamesGP3D);
Gyroscope_Table = cell2table(initial5, 'VariableNames', NamesGyro);
Accelerometer_Table = cell2table(initial5, 'VariableNames', NamesAccel);
PTS_Table = cell2table(initial4, 'VariableNames', NamesPTS);
VTS_Table = cell2table(initial3, 'VariableNames', NamesVTS);
EVTS_Table = cell2table(initial3, 'VariableNames', NamesEVTS);
Sync_Table = cell2table(initial4, 'VariableNames', NamesSyncPort);
API_Table = cell2table(initial5, 'VariableNames', NamesAPI);

% INTIALIZE TABLE COUNTERS
LeftPupilCenter_counter = 1;
RightPupilCenter_counter = 1;
LeftPupilDiameter_counter = 1;
RightPupilDiameter_counter = 1;
LeftGazeDirection_counter = 1;
RightGazeDirection_counter = 1;
GazePosition_counter = 1;
GazePosition3D_counter = 1;
Gyroscope_counter = 1;
Accelerometer_counter = 1;
PTS_counter = 1;
VTS_counter = 1;
EVTS_counter = 1;
Sync_counter = 1;
API_counter = 1;

% read each line of the file loop
while feof(file)==0
    
    line = fgetl(file);
    line_decoded = jsondecode(line);
    field_names = fieldnames(line_decoded);
    
    switch length(field_names)

        % evaluate case of 5 field names. (LeftPC, RightPC, LeftPD,
        % RightPD, LeftGD, RightGD, GP, API)
        case 5
            %disp(5)
            last_field = field_names(5,1);
          
            % evaluate if line contains field 'eye'. (LeftPC, RightPC,
            % LeftPD, RightPD, LeftGD, RightGD)
            if strcmp(last_field, 'eye')
                field4 = field_names(4,1);
                
                % evaluate if 'eye' field is = left. (LeftPC, LeftPD, LeftGD)
                if strcmp(line_decoded.eye, 'left')
                    
                    % evaluate if line contains 'pc'. (LeftPC)
                    if strcmp(field4, 'pc')
                        
                        tempRow = {(line_decoded.ts * 10^-6) line_decoded.s...
                             line_decoded.gidx line_decoded.pc(1)...
                             line_decoded.pc(2) line_decoded.pc(3)};
                 
                        LeftPupilCenter_Table(LeftPupilCenter_counter,:) ...
                            = tempRow;
                        
                        LeftPupilCenter_counter = LeftPupilCenter_counter + 1;
                        
                    % evaluate if line contains 'pd'. (LeftPD)
                    elseif strcmp(field4, 'pd')

                        tempRow = {(line_decoded.ts * 10^-6) line_decoded.s ...
                            line_decoded.gidx line_decoded.pd};
                        
                        LeftPupilDiameter_Table(LeftPupilDiameter_counter,:) ...
                            = tempRow;
                        
                        LeftPupilDiameter_counter = LeftPupilDiameter_counter + 1;

                    % evaluate if line contains 'gd'. (LeftGD)
                    elseif strcmp(field4, 'gd')
                        
                        tempRow = {(line_decoded.ts * 10^-6) line_decoded.s line_decoded.gidx...
                            line_decoded.gd(1) line_decoded.gd(2) line_decoded.gd(3)};
                        
                        LeftGazeDirection_Table(LeftGazeDirection_counter,:) ...
                            = tempRow;
                        
                        LeftGazeDirection_counter = LeftGazeDirection_counter + 1;

                    end
                end
                
                % evaluate if 'eye' field is = left. (RightPC, RightPD, RightGD)
                if strcmp(line_decoded.eye, 'right')
                    
                    % evaluate if line contains 'pc'. (RightPC)
                    if strcmp(field4, 'pc')
                        
                        tempRow = {(line_decoded.ts * 10^-6) line_decoded.s...
                             line_decoded.gidx line_decoded.pc(1)...
                             line_decoded.pc(2) line_decoded.pc(3)};
                 
                        RightPupilCenter_Table(RightPupilCenter_counter,:) ...
                            = tempRow;
                        
                        RightPupilCenter_counter = RightPupilCenter_counter + 1;
                        
                    % evaluate if line contains 'pd'. (RightPD)
                    elseif strcmp(field4, 'pd')
                        
                        tempRow = {(line_decoded.ts * 10^-6) line_decoded.s ...
                            line_decoded.gidx line_decoded.pd};
                        
                        RightPupilDiameter_Table(RightPupilDiameter_counter,:) ...
                            = tempRow;
                        
                        RightPupilDiameter_counter = RightPupilDiameter_counter + 1;

                    % evaluate if line contains 'gd'. (RightGD)
                    elseif strcmp(field4, 'gd')
                        
                        tempRow = {(line_decoded.ts * 10^-6) line_decoded.s line_decoded.gidx...
                            line_decoded.gd(1) line_decoded.gd(2) line_decoded.gd(3)};
                        
                        RightGazeDirection_Table(RightGazeDirection_counter,:) ...
                            = tempRow;
                        
                        RightGazeDirection_counter = RightGazeDirection_counter + 1;
                    end
                    
                end
                
            % evaluate if line contains field 'gp' (GP)
            elseif strcmp(last_field, 'gp')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.s line_decoded.gidx...
                    line_decoded.l line_decoded.gp(1) line_decoded.gp(2)};
                
                GazePosition_Table(GazePosition_counter, :) = tempRow;
                
                GazePosition_counter = GazePosition_counter + 1;
                
            % evaluate if line contains field 'tag' (API)
            elseif strcmp(last_field, 'tag')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.s line_decoded.ets...
                    string(line_decoded.type) string(line_decoded.tag)};
                
                API_Table(API_counter,:) = tempRow;
                
                API_counter = API_counter + 1;
               
            end
            
        % evaluate case of 4 field names. (GP3D, SYNC, PTS) 
        case 4
            last_field = field_names(4,1);
            
            % evaluate if line contains field 'gp3' (GP3D)
            if strcmp(last_field, 'gp3')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.s line_decoded.gidx...
                    line_decoded.gp3(1) line_decoded.gp3(2) line_decoded.gp3(3)};
                
                GazePosition3D_Table(GazePosition3D_counter,:) = tempRow;
                
                GazePosition3D_counter = GazePosition3D_counter + 1;
            
            % evaluate if line contains field 'sig' (SYNC)
            elseif strcmp(last_field, 'sig')
                
                if strcmp(line_decoded.dir, 'in')
                    tempDir = 1;
                elseif strcmp(line_decoded.dir, 'out')
                    tempDir = 0;
                end
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.s ...
                    tempDir line_decoded.sig};
                
                Sync_Table(Sync_counter,:) = tempRow;
                
                Sync_counter = Sync_counter + 1;

            % evaluate if line contains field 's' (PTS)    
            elseif strcmp(last_field, 's')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.pts line_decoded.pv...
                    line_decoded.s};
                
                PTS_Table(PTS_counter,:) = tempRow;
                
                PTS_counter = PTS_counter + 1;
                
            end
            
        % evaluate case of 3 field names. (Gyro, Accel, VTS, EVTS)     
        case 3
            field2 = field_names(2,1);
            field3 = field_names(3,1);
            
            % evaluate if line contains field 'gy' (Gyro) 
            if strcmp(field2,'gy') || strcmp(field3,'gy')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.gy(1)...
                    line_decoded.gy(2) line_decoded.gy(3) line_decoded.s};
                
                Gyroscope_Table(Gyroscope_counter,:) = tempRow;
                
                Gyroscope_counter = Gyroscope_counter + 1;
           
            % evaluate if line contains field 'ac' (Accel)
            elseif strcmp(field2,'ac') || strcmp(field3,'ac')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.ac(1)...
                    line_decoded.ac(2) line_decoded.ac(3) line_decoded.s};
                
                Accelerometer_Table(Accelerometer_counter,:) = tempRow;
                
                Accelerometer_counter = Accelerometer_counter + 1;
                
            % evaluate if line contains field 'vts' (VTS)    
            elseif strcmp(field2,'vts') || strcmp(field3,'vts')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.vts line_decoded.s};
                
                VTS_Table(VTS_counter,:) = tempRow;
                
                VTS_counter = VTS_counter + 1;
            
            % evaluate if 2nd field is 's' (EVTS)   
            elseif strcmp(field2,'evts') || strcmp(field3,'evts')
                
                tempRow = {(line_decoded.ts * 10^-6) line_decoded.evts line_decoded.s};
                
                EVTS_Table(EVTS_counter,:) = tempRow;
                
                EVTS_counter = EVTS_counter + 1;
                
            end
         
    end

%     disp('paused')
%     pause
    
end 
% end of read each line of the file loop

% CONVERT TIMESTAMP COLUMNS TO DURATION OBJECTS 

LeftPupilCenter_Table.Timestamp = seconds(LeftPupilCenter_Table.Timestamp);
RightPupilCenter_Table.Timestamp = seconds(RightPupilCenter_Table.Timestamp);
LeftPupilDiameter_Table.Timestamp = seconds(LeftPupilDiameter_Table.Timestamp);
RightPupilDiameter_Table.Timestamp = seconds(RightPupilDiameter_Table.Timestamp);
LeftGazeDirection_Table.Timestamp = seconds(LeftGazeDirection_Table.Timestamp);
RightGazeDirection_Table.Timestamp = seconds(RightGazeDirection_Table.Timestamp);
GazePosition_Table.Timestamp = seconds(GazePosition_Table.Timestamp);
GazePosition3D_Table.Timestamp = seconds(GazePosition3D_Table.Timestamp);
Gyroscope_Table.Timestamp = seconds(Gyroscope_Table.Timestamp);
Accelerometer_Table.Timestamp = seconds(Accelerometer_Table.Timestamp);
PTS_Table.Timestamp = seconds(PTS_Table.Timestamp);
VTS_Table.Timestamp = seconds(VTS_Table.Timestamp);
EVTS_Table.Timestamp = seconds(EVTS_Table.Timestamp);
Sync_Table.Timestamp = seconds(Sync_Table.Timestamp);
API_Table.Timestamp = seconds(API_Table.Timestamp);

% COMPUTE MIN TIMESTAMP VALUES FOR EACH TABLE

minTimestampValues = [min(LeftPupilCenter_Table.Timestamp); ...
    min(RightPupilCenter_Table.Timestamp); ...
    min(LeftPupilDiameter_Table.Timestamp); ...
    min(RightPupilDiameter_Table.Timestamp); ...
    min(LeftGazeDirection_Table.Timestamp); ...
    min(RightGazeDirection_Table.Timestamp); ...
    min(GazePosition_Table.Timestamp); ...
    min(GazePosition3D_Table.Timestamp); ...
    min(Gyroscope_Table.Timestamp); ...
    min(Accelerometer_Table.Timestamp); ...
    min(PTS_Table.Timestamp); ...
    min(VTS_Table.Timestamp); ...
    min(EVTS_Table.Timestamp); ...
    min(Sync_Table.Timestamp); ...
    min(API_Table.Timestamp)];

minTimestamp = min(minTimestampValues);

% SUBTRACT LOWEST TIMESTAMP VALUE FROM ALL TIMESTAMPS AND ADD START TIME

LeftPupilCenter_Table.Timestamp = start_date + start_time + ...
    LeftPupilCenter_Table.Timestamp - minTimestamp;
RightPupilCenter_Table.Timestamp = start_date + start_time + ... 
    RightPupilCenter_Table.Timestamp - minTimestamp;
LeftPupilDiameter_Table.Timestamp = start_date + start_time + ... 
    LeftPupilDiameter_Table.Timestamp - minTimestamp;
RightPupilDiameter_Table.Timestamp = start_date + start_time + ... 
    RightPupilDiameter_Table.Timestamp - minTimestamp;
LeftGazeDirection_Table.Timestamp = start_date + start_time + ... 
    LeftGazeDirection_Table.Timestamp - minTimestamp;
RightGazeDirection_Table.Timestamp = start_date + start_time + ... 
    RightGazeDirection_Table.Timestamp - minTimestamp;
GazePosition_Table.Timestamp = start_date + start_time +...
    GazePosition_Table.Timestamp - minTimestamp;
GazePosition3D_Table.Timestamp = start_date + start_time + ...
    GazePosition3D_Table.Timestamp - minTimestamp;
Gyroscope_Table.Timestamp = start_date + start_time + ...
    Gyroscope_Table.Timestamp - minTimestamp;
Accelerometer_Table.Timestamp = start_date + start_time + ...
    Accelerometer_Table.Timestamp - minTimestamp;
PTS_Table.Timestamp = start_date + start_time + PTS_Table.Timestamp ...
    - minTimestamp;
VTS_Table.Timestamp = start_date + start_time + VTS_Table.Timestamp ...
    - minTimestamp;
EVTS_Table.Timestamp = start_date + start_time + EVTS_Table.Timestamp ...
    - minTimestamp;
Sync_Table.Timestamp = start_date + start_time + Sync_Table.Timestamp ...
    - minTimestamp;
API_Table.Timestamp = start_date + start_time + API_Table.Timestamp ...
    - minTimestamp;

% change default datetime format
datetime.setDefaultFormats('default', 'dd-MMM-uuuu HH:mm:ss.SSSS');

% SORT TABLES BY TIMESTAMP

LeftPupilCenter_Table = sortrows(LeftPupilCenter_Table);
RightPupilCenter_Table = sortrows(RightPupilCenter_Table);
LeftPupilDiameter_Table = sortrows(LeftPupilDiameter_Table);
RightPupilDiameter_Table = sortrows(RightPupilDiameter_Table);
LeftGazeDirection_Table = sortrows(LeftGazeDirection_Table);
RightGazeDirection_Table = sortrows(RightGazeDirection_Table);
GazePosition_Table = sortrows(GazePosition_Table);
GazePosition3D_Table = sortrows(GazePosition3D_Table);
Gyroscope_Table = sortrows(Gyroscope_Table);
Accelerometer_Table = sortrows(Accelerometer_Table);
PTS_Table = sortrows(PTS_Table);
VTS_Table = sortrows(VTS_Table);
EVTS_Table = sortrows(EVTS_Table);
Sync_Table = sortrows(Sync_Table);
API_Table = sortrows(API_Table);

% CONVERT TABLES TO TIMETABLES

LeftPupilCenter_Timetable = table2timetable(LeftPupilCenter_Table);
RightPupilCenter_Timetable = table2timetable(RightPupilCenter_Table);
LeftPupilDiameter_Timetable = table2timetable(LeftPupilDiameter_Table);
RightPupilDiameter_Timetable= table2timetable(RightPupilDiameter_Table);
LeftGazeDirection_Timetable= table2timetable(LeftGazeDirection_Table);
RightGazeDirection_Timetable = table2timetable(RightGazeDirection_Table);
GazePosition_Timetable = table2timetable(GazePosition_Table);
GazePosition3D_Timetable = table2timetable(GazePosition3D_Table);
Gyroscope_Timetable = table2timetable(Gyroscope_Table);
Accelerometer_Timetable = table2timetable(Accelerometer_Table);
PTS_Timetable = table2timetable(PTS_Table);
VTS_Timetable = table2timetable(VTS_Table);
EVTS_Timetable = table2timetable(EVTS_Table);
Sync_Timetable = table2timetable(Sync_Table);
API_Timetable = table2timetable(API_Table);

% SYNCRONIZE TIMETABLES

% construct timetable of biometric measurements
TobiiData_Timetable = synchronize(...
    LeftPupilCenter_Timetable, RightPupilCenter_Timetable, ...
    LeftPupilDiameter_Timetable, RightPupilDiameter_Timetable, ...
    LeftGazeDirection_Timetable, RightGazeDirection_Timetable, ...
    GazePosition_Timetable, GazePosition3D_Timetable, ...
    Gyroscope_Timetable, Accelerometer_Timetable);

% TobiiData_Timetable.Timestamp = TobiiData_Timetable.Timestamp - hours(5);
TobiiData_Timetable = unique(TobiiData_Timetable);
% construct timetable of auxiliary parameters that were measured during run

% build command
command = 'Auxiliary_Timetable = synchronize(';

if length(PTS_Timetable.Timestamp) > 1 
    command = [command 'PTS_Timetable, '];
end

if length(VTS_Timetable.Timestamp) > 1 
    command = [command 'VTS_Timetable, '];
end

if length(EVTS_Timetable.Timestamp) > 1 
    command = [command 'EVTS_Timetable, '];
end

if length(API_Timetable.Timestamp) > 1
    command = [command 'API_Timetable, '];
end

if length(Sync_Timetable.Timestamp) > 1 
    command = [command 'Sync_Timetable'];  
end

% evaluate command
if length(command) > 34
    command = [command ');'];
    eval(command)
end

% save timetables to file
save(strcat("objects/Tobii/", Run,"_Timetable.mat",'TobiiData_Timetable'));
save(strcat("objects/Tobii/",Run,"_Auxiliary_Timetable.mat",'Auxiliary_Timetable'));
