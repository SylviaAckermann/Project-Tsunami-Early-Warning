%% Auswertung der Rohdaten mit Kalman-Filter

close all
wmclose('all')
clc

plotRawData = true;
plotFilteredData = true;
plotFilteredData_onMap = false;

%[posData, imuData] = loadRawData();

%phones = {'H1','H2','H4','H5','H6','H7'};
phones = {'H4'};

[data_pos, data_acc] = process_plot_RawData(phones, posData, imuData, plotRawData);

% To-Do: implementiere Integrated Random Walk
stochastic_process = "RW";  % RW = Random Walk, IRW = Integrated Random Walk
[data_filtered, time] = KalmanFilter(data_pos, data_acc, stochastic_process);

% To-Do: calculate distance and azimuth of movement

if plotFilteredData
    plot_filteredData(phones, data_filtered, time);
end

%% Darstellung in Karte
if plotFilteredData_onMap
    %Lat_raw = posData{1,1}.data(:,1);
    %Lon_raw = posData{1,1}.data(:,2);
    
    Lat = data_filtered{1,1}(:,1);
    Lon = data_filtered{1,1}(:,2);
    
    wm = webmap('World Imagery');
    wmline(Lat,Lon,'Color','black','FeatureName','H1','Color','magenta','FeatureName','H1')
end
