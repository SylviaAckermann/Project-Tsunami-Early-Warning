%% Auswertung Dynamische Messungen

clc, clear, close all; 

wmclose('all')

%% load data
% Bezeichnung der Handys
%namesMat = {'H1' 'H2' 'H3' 'H4' 'H5' 'H6' 'H7'}; 
% namesRaw = {'H1' 'H2' 'H4' 'H5' 'H6' 'H7'}; 
%namesIMU = {'H2' 'H4' 'H6' 'H7'};
%namesNMEA = {'H1' 'H2' 'H3' 'H4' 'H5' 'H6' 'H7'}; 
namesNMEA = {'H6'};

%% nmea Daten 
day = datetime('31-Jan-2024');
folder = "..\Daten_neueHandys\";
H6 = folder+"gnss_log_2024_02_06_09_30_24_H6.nmea";
%H6 = folder+"gnss_log_2024_01_31_15_30_01_H6.nmea";
H8 = folder+"gnss_log_2024_01_31_15_30_17_H8.nmea";
nmeaH6 = fopen(H6,'r');
dataNMEA.H6 = loadNMEA(nmeaH6,day,'H6 - Xiaomi');
%nmeaH8 = fopen(H8,'r');
%dataNMEA.H8 = loadNMEA(nmeaH8,day,'H8 - GooglePixel');

clear nmeaH1 nmeaH2 nmeaH3 nmeaH4 nmeaH5 nmeaH6 nmeaH7 nmeaH8
