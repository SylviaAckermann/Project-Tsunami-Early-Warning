function [posData, imuData] = loadRawData_nmea()

% Positionsdaten 
folder = "..\12.12.2023\";
H1 = folder+"gnss_log_2023_12_12_10_30_50_H1";
H2 = folder+"gnss_log_2023_12_12_10_30_11_H2";
H3 = folder+"gnss_log_2023_12_12_10_30_03_H3";
H4 = folder+"gnss_log_2023_12_12_10_22_57_H4";
H5 = folder+"gnss_log_2023_12_12_10_29_19_H5";
H6 = folder+"gnss_log_2023_12_12_10_22_41_H6";
H7 = folder+"gnss_log_2023_12_12_10_28_52_H7";

% Positionsdaten
posData.H1 = loadpos_nmea(H1+".nmea");
posData.H2 = loadpos_nmea(H2+".nmea");
posData.H3 = loadpos_nmea(H3+".nmea");
posData.H4 = loadpos_nmea(H4+".nmea");
posData.H5 = loadpos_nmea(H5+".nmea");
posData.H6 = loadpos_nmea(H6+".nmea");
posData.H7 = loadpos_nmea(H7+".nmea");

% IMU-Daten
imuData.H2 = loadIMU(H2+".txt");
imuData.H4 = loadIMU(H4+".txt");
imuData.H6 = loadIMU(H6+".txt");
imuData.H7 = loadIMU(H7+".txt");

end