function [posData, imuData] = loadRawData()

% Positionsdaten 
H1 = "12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_30_50_H1";
H2 = "12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_30_11_H2";
H4 = "12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_22_57_H4";
H5 = "12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_29_19_H5";
H6 = "12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_22_41_H6";
H7 = "12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_28_52_H7";

% Positionsdaten
posData.H1 = loadpos(H1+".pos");
posData.H2 = loadpos(H2+".pos");
posData.H4 = loadpos(H4+".pos");
posData.H5 = loadpos(H5+".pos");
posData.H6 = loadpos(H6+".pos");
posData.H7 = loadpos(H7+".pos");

% IMU-Daten
imuData.H2 = loadIMU(H2+".txt");
imuData.H4 = loadIMU(H4+".txt");
imuData.H6 = loadIMU(H6+".txt");
imuData.H7 = loadIMU(H7+".txt");

end