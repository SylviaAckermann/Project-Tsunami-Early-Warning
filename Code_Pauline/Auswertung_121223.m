%% Auswertung Dynamische Messungen

clc, clear, close all; 

wmclose('all')

%% load data
% Einlesen der Matlab-Daten
dataMat.H1 = load("Positionen_121223\sensorlog_20231212_103057_H1.mat");
dataMat.H2 = load("Positionen_121223\Messung_H2.mat");
dataMat.H3 = load("Positionen_121223\sensorlog_20231212_102944_H3.mat");
dataMat.H4 = load("Positionen_121223\sensorlog_20231212_102253_H4.mat");
dataMat.H5 = load("Positionen_121223\sensorlog_20231212_102909H5.mat");
dataMat.H6 = load("Positionen_121223\sensorlog_20231212_102237_H6.mat");
dataMat.H7 = load("Positionen_121223\sensorlog_20231212_092932_H7.mat");
% 
% % Einlesen der Rohdaten 
% dataRaw.H1.Position = loadpos('RohdatenAuswertung_121223\gnss_log_2023_12_12_10_30_50_H1.pos');
% dataRaw.H2.Position = loadpos('RohdatenAuswertung_121223\gnss_log_2023_12_12_10_30_11_H2.pos');
% % dataRaw.H3.Position = loadpos('RohdatenAuswertung_121223\');
% dataRaw.H4.Position = loadpos('RohdatenAuswertung_121223\gnss_log_2023_12_12_10_22_57_H4.pos');
% dataRaw.H5.Position = loadpos('RohdatenAuswertung_121223\gnss_log_2023_12_12_10_29_19_H5.pos');
% dataRaw.H6.Position = loadpos('RohdatenAuswertung_121223\gnss_log_2023_12_12_10_22_41_H6.pos');
% dataRaw.H7.Position = loadpos('RohdatenAuswertung_121223\gnss_log_2023_12_12_10_28_52_H7.pos');
% 
% Einlesen der IMU-Daten
% dataRaw.H1.IMU = loadIMU("RohdatenAuswertung_121223", [30, Inf]);
dataRaw.H2.IMU = loadIMU("RohdatenAuswertung_121223\gnss_log_2023_12_12_10_30_11_H2.txt", [30, Inf]);
% dataRaw.H3.IMU = loadIMU();
dataRaw.H4.IMU = loadIMU("RohdatenAuswertung_121223\gnss_log_2023_12_12_10_22_57_H4.txt", [30, Inf]);
% dataRaw.H5.IMU = loadIMU("RohdatenAuswertung_121223", [30, Inf]);
dataRaw.H6.IMU = loadIMU("RohdatenAuswertung_121223\gnss_log_2023_12_12_10_22_41_H6.txt", [30, Inf]);
dataRaw.H7.IMU = loadIMU("RohdatenAuswertung_121223\gnss_log_2023_12_12_10_28_52_H7.txt", [30, Inf]);

% Bezeichnung der Handys
namesMat = {'H1' 'H2' 'H3' 'H4' 'H5' 'H6' 'H7'}; 
% namesRaw = {'H1' 'H2' 'H4' 'H5' 'H6' 'H7'}; 
namesIMU = {'H2' 'H4' 'H6' 'H7'};
namesNMEA = {'H1' 'H2' 'H3' 'H4' 'H5' 'H6' 'H7'}; 

%% nmea Daten 
day = datetime('12-Dec-2023');
nmeaH1 = fopen('RohdatenMessungen_121223/gnss_log_2023_12_12_10_30_50_H1.nmea','r');
dataNMEA.H1 = loadNMEA(nmeaH1,day);
nmeaH2 = fopen('RohdatenMessungen_121223/gnss_log_2023_12_12_10_30_11_H2.nmea','r');
dataNMEA.H2= loadNMEA(nmeaH2,day);
nmeaH3 = fopen('RohdatenMessungen_121223/gnss_log_2023_12_12_10_30_03_H3.nmea','r');
dataNMEA.H3 = loadNMEA(nmeaH3,day);
nmeaH4 = fopen('RohdatenMessungen_121223/gnss_log_2023_12_12_10_22_57_H4.nmea','r');
dataNMEA.H4 = loadNMEA(nmeaH4,day);
nmeaH5 = fopen('RohdatenMessungen_121223/gnss_log_2023_12_12_10_29_19_H5.nmea','r');
dataNMEA.H5 = loadNMEA(nmeaH5,day);
nmeaH6 = fopen('RohdatenMessungen_121223/gnss_log_2023_12_12_10_22_41_H6.nmea','r');
dataNMEA.H6 = loadNMEA(nmeaH6,day);
nmeaH7 = fopen('RohdatenMessungen_121223/gnss_log_2023_12_12_10_28_52_H7.nmea','r');
dataNMEA.H7 = loadNMEA(nmeaH7,day);

clear nmeaH1 nmeaH2 nmeaH3 nmeaH4 nmeaH5 nmeaH6 nmeaH7

%% Vorverarbeitung
% Entfernen der ersten und letzten Messungen, um Bewegungen durch Ein- und
% Ausschalten zu eliminieren 
for i = 1:length(namesMat) -2
    index_start = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:31:00.000'); 
    index_ende = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:50:00.000');
    dataMat.(namesMat{i}).Position = dataMat.(namesMat{i}).Position(index_start:index_ende,:);
end

for i = 1:length(namesIMU)
    dataRaw.(namesIMU{i}).IMU.orientationDeg = dataRaw.(namesIMU{i}).IMU.orientationDeg(50:end-50,:);
    dataRaw.(namesIMU{i}).IMU.acceleration = dataRaw.(namesIMU{i}).IMU.acceleration(50:end-50,:);
    dataRaw.(namesIMU{i}).IMU.gyroscopeUncal = dataRaw.(namesIMU{i}).IMU.gyroscopeUncal(50:end-50,:);
    dataRaw.(namesIMU{i}).IMU.magnitudeUncal = dataRaw.(namesIMU{i}).IMU.magnitudeUncal(50:end-50,:);
end

for i = 1:length(namesNMEA)
    index_start = find(dataNMEA.(namesNMEA{i}).time == '12-Dec-2023 10:31:00.000'); 
    index_ende = find(dataNMEA.(namesNMEA{i}).time == '12-Dec-2023 11:46:00.000');
    dataNMEA.(namesNMEA{i}) = dataNMEA.(namesNMEA{i})(index_start:index_ende,:);
end


% Umrechnung in enu-System
% Approximation 'flat' -> laut Matlab höhere Genauigkeiten über kurze
% Distanzen

lla0 = [48.7411111 9.1119444 300]; % [lat0 lon0 alt0] Ursprung für lokales Koordinatensystem (südliches Epizentrum)

for i = 1:length(namesMat)
    ENU = lla2enu([dataMat.(namesMat{i}).Position.latitude, dataMat.(namesMat{i}).Position.longitude, dataMat.(namesMat{i}).Position.altitude], lla0, 'flat');
    dataMat.(namesMat{i}).Position.east = ENU(:,1);
    dataMat.(namesMat{i}).Position.north = ENU(:,2);
    dataMat.(namesMat{i}).Position.up = ENU(:,3);
    clear ENU
end
% 
% for i = 1:length(namesRaw)
%     ENU = lla2enu([dataRaw.(namesRaw{i}).Position.latitude, dataRaw.(namesRaw{i}).Position.longitude, dataRaw.(namesRaw{i}).Position.height], lla0, 'flat');
%     dataRaw.(namesRaw{i}).Position.east = ENU(:,1);
%     dataRaw.(namesRaw{i}).Position.north = ENU(:,2);
%     dataRaw.(namesRaw{i}).Position.up = ENU(:,3);
%     clear ENU
% end

for i = 1:length(namesNMEA)
    ENU = lla2enu([dataNMEA.(namesNMEA{i}).latitude, dataNMEA.(namesNMEA{i}).longitude, dataNMEA.(namesNMEA{i}).altitude], lla0, 'flat');
    dataNMEA.(namesNMEA{i}).east = ENU(:,1);
    dataNMEA.(namesNMEA{i}).north = ENU(:,2);
    dataNMEA.(namesNMEA{i}).up = ENU(:,3);
    clear ENU
end

%% Berechnungen
std_H = zeros(length(namesMat),3);

% Berechnung der mittleren Position und den Abweichungen/Streuung dazu 
% Berechung der Standardabweichungen 
for i = 1:length(namesMat)
    index_start = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:30:30.000'); 
    index_ende = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:44:30.000');
    std_H(i,:) = std([dataMat.(namesMat{i}).Position.east,dataMat.(namesMat{i}).Position.north,dataMat.(namesMat{i}).Position.up]); % Std in [m]
    dataMat.(namesMat{i}).Calc.startPos = [mean(dataMat.(namesMat{i}).Position.east(index_start:index_ende)), mean(dataMat.(namesMat{i}).Position.north(index_start:index_ende))];
    dataMat.(namesMat{i}).Calc.dist = sqrt((dataMat.(namesMat{i}).Calc.startPos(1)-dataMat.(namesMat{i}).Position.east).^2 + (dataMat.(namesMat{i}).Calc.startPos(2)-dataMat.(namesMat{i}).Position.north).^2);
end

% % Mittelbildung der ausgewerteten Rohdaten
% n = 30;
% for i = 1:length(namesRaw)
%     dataRaw.(namesRaw{i}).Mean.date = dataRaw.(namesRaw{i}).Position.date(1:end-30);
%     for j = 1 : length(dataRaw.(namesRaw{i}).Position.east)-n
%         dataRaw.(namesRaw{i}).Mean.east(j) = mean(dataRaw.(namesRaw{i}).Position.east(j:(j+n),:));
%         dataRaw.(namesRaw{i}).Mean.north(j) = mean(dataRaw.(namesRaw{i}).Position.north(j:(j+n),:));
%         dataRaw.(namesRaw{i}).Mean.up(j) = mean(dataRaw.(namesRaw{i}).Position.up(j:(j+n),:));
%     end
% end

%% Plots
% for i = 1:length(namesMat)
%     figure()
%     t = tiledlayout(1,2);
%     title(t,"Matlab ", namesMat{i})
%     nexttile
%     plot(dataMat.(namesMat{i}).Position.Timestamp, dataMat.(namesMat{i}).Position.east,'.')
%     ylabel('east [m]')
%     nexttile
%     plot(dataMat.(namesMat{i}).Position.Timestamp, dataMat.(namesMat{i}).Position.north,'.')
%     ylabel('north [m]')
% end


% % Höhenplot
% figure()
% hold on 
% for i = 1:length(namesMat)
%     plot(dataMat.(namesMat{i}).Position.Timestamp, dataMat.(namesMat{i}).Position.altitude,'.','MarkerSize',10)
% end
% legend(namesMat, 'Location', 'best')
% title('Matlab Altitude')
% ylabel('altitude [m]')


% for i = 1:length(namesMat)
%     figure()
%     t = tiledlayout(3,1);
%     title(t,['Matlab Acceleration ', namesMat{i}])
%     nexttile
%     plot(dataMat.(namesMat{i}).Acceleration.Timestamp, dataMat.(namesMat{i}).Acceleration.X,'.')
%     ylabel('IMU X')
%     grid on
%     nexttile
%     plot(dataMat.(namesMat{i}).Acceleration.Timestamp, dataMat.(namesMat{i}).Acceleration.Y,'.')
%     ylabel('IMU Y')
%     grid on
%     nexttile
%     plot(dataMat.(namesMat{i}).Acceleration.Timestamp, dataMat.(namesMat{i}).Acceleration.Z,'.')
%     ylabel('IMU Z')
%     grid on
% end


%% Plots mit Bewegungszeitpunkten
 points = [datetime('12-Dec-2023 10:45:00.000');
           datetime('12-Dec-2023 10:55:00.000');
           datetime('12-Dec-2023 11:10:00.000');
           datetime('12-Dec-2023 11:20:00.000');
           datetime('12-Dec-2023 11:35:00.000')];

 for i = 1:length(namesMat)
    figure()
    t = tiledlayout(2,1);
    title(t,"Matlab", namesMat{i})
    nexttile
    plot(dataMat.(namesMat{i}).Position.Timestamp,dataMat.(namesMat{i}).Position.longitude,'.')
    hold on
    xline(points,'--',{'1','2','3','4','5'})
    ylabel('[°]');xlabel('Time');
    title('longitude')

    nexttile
    plot(dataMat.(namesMat{i}).Position.Timestamp,dataMat.(namesMat{i}).Position.latitude,'.')
    hold on
    xline(points,'--',{'1','2','3','4','5'})
    ylabel('[°]');xlabel('Time');
    title('latitude')

end

%% Berechung der Bewegung durch Erdbeben (Matlab) 

% for i = 2:length(namesMat)-2
% % Berechnung der Distanzen der Bewegungen. Dazu wird jeweils das Mittel der
% % Position in X und Y Richtung während den Ruhepausen berechnet und dazu
% % die Abweichung bestimmt. 
% 
%     % erste Bewegung (zentrales Epizentrum, 50 m Slip) 
%     start_index(1) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:31:00.000'); 
%     end_index(1) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:44:30.000');
%     end_move(1) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:46:30.000');
%     dataMat.(namesMat{i}).Calc.PosX(1) = mean(dataMat.(namesMat{i}).Position.east(start_index(1):end_index(1),:));
%     dataMat.(namesMat{i}).Calc.distX(start_index:end_move(1)) = dataMat.(namesMat{i}).Position.east(start_index(1):end_move(1)) - dataMat.(namesMat{i}).Calc.PosX(1);
%     dataMat.(namesMat{i}).Calc.PosY(1) = mean(dataMat.(namesMat{i}).Position.north(start_index(1):end_index(1),:));
%     dataMat.(namesMat{i}).Calc.distY(start_index:end_move(1)) = dataMat.(namesMat{i}).Position.north(start_index(1):end_move(1)) - dataMat.(namesMat{i}).Calc.PosY(1);
% 
%     % zweite Bewegung (südliches Epizentrum, 50 m Slip) 
%     start_index(2) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:47:00.000'); 
%     end_index(2) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:54:00.000');
%     end_move(2) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:56:30.000');
%     dataMat.(namesMat{i}).Calc.PosX(2) = mean(dataMat.(namesMat{i}).Position.east(start_index(2):end_index(2),:));
%     dataMat.(namesMat{i}).Calc.distX(end_move(1)+1:end_move(2)) = dataMat.(namesMat{i}).Position.east(end_move(1)+1:end_move(2)) - dataMat.(namesMat{i}).Calc.PosX(2);
%     dataMat.(namesMat{i}).Calc.PosY(2) = mean(dataMat.(namesMat{i}).Position.north(start_index(2):end_index(2),:));
%     dataMat.(namesMat{i}).Calc.distY(end_move(1)+1:end_move(2)) = dataMat.(namesMat{i}).Position.north(end_move(1)+1:end_move(2)) - dataMat.(namesMat{i}).Calc.PosY(2);
% 
%     % dritte Bewegung (südliches Epizentrum, 40 m Slip) 
%     start_index(3) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 10:57:00.000'); 
%     end_index(3) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:09:00.000');
%     end_move(3) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:11:30.000');
%     dataMat.(namesMat{i}).Calc.PosX(3) = mean(dataMat.(namesMat{i}).Position.east(start_index(3):end_index(3),:));
%     dataMat.(namesMat{i}).Calc.distX(end_move(2)+1:end_move(3)) = dataMat.(namesMat{i}).Position.east(end_move(2)+1:end_move(3)) - dataMat.(namesMat{i}).Calc.PosX(3);
%     dataMat.(namesMat{i}).Calc.PosY(3) = mean(dataMat.(namesMat{i}).Position.north(start_index(3):end_index(3),:));
%     dataMat.(namesMat{i}).Calc.distY(end_move(2)+1:end_move(3)) = dataMat.(namesMat{i}).Position.north(end_move(2)+1:end_move(3)) - dataMat.(namesMat{i}).Calc.PosY(3);
% 
%     % vierte Bewegung (südliches Epizentrum, 30 m Slip) 
%     start_index(4) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:12:00.000'); 
%     end_index(4) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:19:00.000');
%     end_move(4) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:21:30.000');
%     dataMat.(namesMat{i}).Calc.PosX(4) = mean(dataMat.(namesMat{i}).Position.east(start_index(4):end_index(4),:));
%     dataMat.(namesMat{i}).Calc.distX(end_move(3)+1:end_move(4)) = dataMat.(namesMat{i}).Position.east(end_move(3)+1:end_move(4)) - dataMat.(namesMat{i}).Calc.PosX(4);
%     dataMat.(namesMat{i}).Calc.PosY(4) = mean(dataMat.(namesMat{i}).Position.north(start_index(4):end_index(4),:));
%     dataMat.(namesMat{i}).Calc.distY(end_move(3)+1:end_move(4)) = dataMat.(namesMat{i}).Position.north(end_move(3)+1:end_move(4)) - dataMat.(namesMat{i}).Calc.PosY(4);
% 
%     % fünfte Bewegung (südliches Epizentrum, 30 m Slip) 
%     start_index(5) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:22:00.000'); 
%     end_index(5) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:34:00.000');
%     end_move(5) = find(dataMat.(namesMat{i}).Position.Timestamp == '12-Dec-2023 11:50:00.000');
%     dataMat.(namesMat{i}).Calc.PosX(5) = mean(dataMat.(namesMat{i}).Position.east(start_index(5):end_index(5),:));
%     dataMat.(namesMat{i}).Calc.distX(end_move(4)+1:end_move(5)) = dataMat.(namesMat{i}).Position.east(end_move(4)+1:end_move(5)) - dataMat.(namesMat{i}).Calc.PosX(5);
%     dataMat.(namesMat{i}).Calc.PosY(5) = mean(dataMat.(namesMat{i}).Position.north(start_index(5):end_index(5),:));
%     dataMat.(namesMat{i}).Calc.distY(end_move(4)+1:end_move(5)) = dataMat.(namesMat{i}).Position.north(end_move(4)+1:end_move(5)) - dataMat.(namesMat{i}).Calc.PosY(5);
% 
%     % Berechnung der maximalen Bewegung und des Azimuts
%     % 1. Erdbeben
%     earthquake_1.(namesMat{i}).distX = max(dataMat.(namesMat{i}).Calc.distX(start_index:end_move(1)));
%     earthquake_1.(namesMat{i}).distY = max(dataMat.(namesMat{i}).Calc.distY(start_index:end_move(1)));
%     earthquake_1.(namesMat{i}).dist = sqrt(earthquake_1.(namesMat{i}).distX^2+earthquake_1.(namesMat{i}).distY^2);
%     earthquake_1.(namesMat{i}).azimut = atan2(earthquake_1.(namesMat{i}).distY,earthquake_1.(namesMat{i}).distX)*180/pi;
% 
%      % 2. Erdbeben
%     earthquake_2.(namesMat{i}).distX = max(dataMat.(namesMat{i}).Calc.distX(end_move(1)+1:end_move(2)));
%     earthquake_2.(namesMat{i}).distY = max(dataMat.(namesMat{i}).Calc.distY(end_move(1)+1:end_move(2)));
%     earthquake_2.(namesMat{i}).dist = sqrt(earthquake_2.(namesMat{i}).distX^2+earthquake_2.(namesMat{i}).distY^2);
%     earthquake_2.(namesMat{i}).azimut = atan2(earthquake_2.(namesMat{i}).distY,earthquake_2.(namesMat{i}).distX)*180/pi;
% 
%     % 3. Erdbeben
%     earthquake_3.(namesMat{i}).distX = max(dataMat.(namesMat{i}).Calc.distX(end_move(2)+1:end_move(3)));
%     earthquake_3.(namesMat{i}).distY = max(dataMat.(namesMat{i}).Calc.distY(end_move(2)+1:end_move(3)));
%     earthquake_3.(namesMat{i}).dist = sqrt(earthquake_2.(namesMat{i}).distX^2+earthquake_2.(namesMat{i}).distY^2);
%     earthquake_3.(namesMat{i}).azimut = atan2(earthquake_2.(namesMat{i}).distY,earthquake_2.(namesMat{i}).distX)*180/pi;
% 
%     % 4. Erdbeben
%     earthquake_4.(namesMat{i}).distX = max(dataMat.(namesMat{i}).Calc.distX(end_move(3)+1:end_move(4)));
%     earthquake_4.(namesMat{i}).distY = max(dataMat.(namesMat{i}).Calc.distY(end_move(3)+1:end_move(4)));
%     earthquake_4.(namesMat{i}).dist = sqrt(earthquake_2.(namesMat{i}).distX^2+earthquake_2.(namesMat{i}).distY^2);
%     earthquake_4.(namesMat{i}).azimut = atan2(earthquake_2.(namesMat{i}).distY,earthquake_2.(namesMat{i}).distX)*180/pi;
% 
%     % 5. Erdbeben
%     earthquake_5.(namesMat{i}).distX = max(dataMat.(namesMat{i}).Calc.distX(end_move(4)+1:end_move(5)));
%     earthquake_5.(namesMat{i}).distY = max(dataMat.(namesMat{i}).Calc.distY(end_move(4)+1:end_move(5)));
%     earthquake_5.(namesMat{i}).dist = sqrt(earthquake_2.(namesMat{i}).distX^2+earthquake_2.(namesMat{i}).distY^2);
%     earthquake_5.(namesMat{i}).azimut = atan2(earthquake_2.(namesMat{i}).distY,earthquake_2.(namesMat{i}).distX)*180/pi;
% 
%     figure()
%     t = tiledlayout(2,1);
%     title(t,"Matlab", namesMat{i})
%     nexttile
%     hold on
%     yyaxis left
%     plot(dataMat.(namesMat{i}).Position.Timestamp,dataMat.(namesMat{i}).Calc.distX,'.')
%     ylabel('Bewegungen X [m]')
%     yyaxis right
%     plot(dataMat.(namesMat{i}).Acceleration.Timestamp,dataMat.(namesMat{i}).Acceleration.X,'-')
%     ylabel('Beschleunigung X [m/s^2]')
%     xline(points,'Color','green')
%     grid on
%     title('X-Richtung')
% 
%     nexttile
%     hold on
%     yyaxis left
%     plot(dataMat.(namesMat{i}).Position.Timestamp,dataMat.(namesMat{i}).Calc.distY,'.')
%     ylabel('Bewegungen Y [m]')
%     yyaxis right
%     plot(dataMat.(namesMat{i}).Acceleration.Timestamp,dataMat.(namesMat{i}).Acceleration.Y,'-')
%     ylabel('Beschleunigung Y [m/s^2]')
%     xline(points,'Color','green')
%     grid on
%     title('Y-Richtung')
% end



%% Plots der ausgewerteten Rohdaten 
% Zeitpunkte
% pointsRaw = [datetime('12-Dec-2023 09:45:00.000');
%              datetime('12-Dec-2023 09:55:00.000');
%              datetime('12-Dec-2023 10:10:00.000');
%              datetime('12-Dec-2023 10:20:00.000');
%              datetime('12-Dec-2023 10:35:00.000')];

% for i = 1:length(namesRaw)
%     figure()
%     t = tiledlayout(2,2);
%     title(t,"Positionen aus Rohdaten", namesRaw{i})
%     nexttile
%     plot(dataRaw.(namesRaw{i}).Position.date,dataRaw.(namesRaw{i}).Position.east)
%     hold on
%     plot(dataRaw.(namesRaw{i}).Mean.date,dataRaw.(namesRaw{i}).Mean.east,'r');
%     xline(points,'--',{'1','2','3','4','5'})
%     ylabel('[m]');xlabel('Time');
%     title('Position in East')
% 
%     nexttile
%     plot(dataRaw.(namesRaw{i}).Position.date, dataRaw.(namesRaw{i}).Position.north)
%     hold on
%     plot(dataRaw.(namesRaw{i}).Mean.date,dataRaw.(namesRaw{i}).Mean.north,'r');
%     xline(points,'--',{'1','2','3','4','5'})
%     ylabel('[m]');xlabel('Time');
%     title('Position in North')
% 
%     nexttile
%     plot(dataRaw.(namesRaw{i}).Position.date, dataRaw.(namesRaw{i}).Position.up)
%     hold on
%     plot(dataRaw.(namesRaw{i}).Mean.date,dataRaw.(namesRaw{i}).Mean.up,'r');
%     xline(points,'--',{'1','2','3','4','5'})
%     ylabel('[m]');xlabel('Time');
%     title('Position in Up')
% 
%     nexttile
%     scatter(dataRaw.(namesRaw{i}).Position.east,dataRaw.(namesRaw{i}).Position.north,'x');hold on;
%     scatter(dataRaw.(namesRaw{i}).Mean.east,dataRaw.(namesRaw{i}).Mean.north,'x','r')
%     ylabel('[m]');xlabel('[m]');
%     title('Position in East, North')
% end

%% Plots IMU (gnss logger) 
for i = 1:length(namesIMU)
    figure()
    t = tiledlayout(2,1);
    title(t,"IMU (gnss logger)", namesIMU{i})
    nexttile
    plot(dataRaw.(namesIMU{i}).IMU.acceleration.date,dataRaw.(namesIMU{i}).IMU.acceleration.AccelXMps2,'.')
    hold on
    xline(points,'--',{'1','2','3','4','5'})
    ylabel('[m/s^2]');xlabel('Time');
    title('x')

    nexttile
    plot(dataRaw.(namesIMU{i}).IMU.acceleration.date,dataRaw.(namesIMU{i}).IMU.acceleration.AccelYMps2,'.')
    hold on
    xline(points,'--',{'1','2','3','4','5'})
    ylabel('[m/s^2]');xlabel('Time');
    title('y')
end


%% Auswertung nmea Daten 
timeEarthquake = [datetime('12-Dec-2023 10:45:00.000','TimeZone','');
                  datetime('12-Dec-2023 10:55:00.000','TimeZone','');
                  datetime('12-Dec-2023 11:10:00.000','TimeZone','');
                  datetime('12-Dec-2023 11:20:00.000','TimeZone','');
                  datetime('12-Dec-2023 11:35:00.000','TimeZone','')];

% Plots der Daten
for i = 1:length(namesNMEA)
    figure()
    t = tiledlayout(2,1);
    title(t,"nmea", namesNMEA{i})
    nexttile
    plot(dataNMEA.(namesNMEA{i}).time,dataNMEA.(namesNMEA{i}).longitude,'.')
    hold on
    xline(timeEarthquake,'--',{'1','2','3','4','5'})
    ylabel('[°]');xlabel('Time');
    title('longtitude')

    nexttile
    plot(dataNMEA.(namesNMEA{i}).time,dataNMEA.(namesNMEA{i}).latitude,'.')
    hold on
    xline(timeEarthquake,'--',{'1','2','3','4','5'})
    ylabel('[°]');xlabel('Time');
    title('latitude')

    figure()
    t = tiledlayout(2,1);
    title(t,"nmea", namesNMEA{i})
    nexttile
    plot(dataNMEA.(namesNMEA{i}).time,dataNMEA.(namesNMEA{i}).east,'.')
    hold on
    xline(timeEarthquake,'--',{'1','2','3','4','5'})
    ylabel('[m]');xlabel('Time');
    title('east')

    nexttile
    plot(dataNMEA.(namesNMEA{i}).time,dataNMEA.(namesNMEA{i}).north,'.')
    hold on
    xline(timeEarthquake,'--',{'1','2','3','4','5'})
    ylabel('[m]');xlabel('Time');
    title('north')
end


% Berechung der Bewegungen

% 1.) Mittel zwischen 10:31 und 10:43
i_start1 = find(dataNMEA.(namesNMEA{i}).time == '12-Dec-2023 10:31:00.000');
i_end1 = find(dataNMEA.(namesNMEA{i}).time == '12-Dec-2023 10:43:00.000');
mean1_east = mean(dataNMEA.(namesNMEA{i}).east(i_start1:i_end1));
mean1_north = mean(dataNMEA.(namesNMEA{i}).north(i_start1:i_end1));

% 2.) Mittel zwischen 10:48 und 10:53
i_start2 = find(dataNMEA.(namesNMEA{i}).time == '12-Dec-2023 10:48:00.000');
i_end2 = find(dataNMEA.(namesNMEA{i}).time == '12-Dec-2023 10:53:00.000');
mean2_east = mean(dataNMEA.(namesNMEA{i}).east(i_start2:i_end2));
mean2_north = mean(dataNMEA.(namesNMEA{i}).north(i_start2:i_end2));

% 3.) Differenzbildung 
dif_east = mean2_east-mean1_east;
dif_north = mean2_north-mean1_north; 
dif = sqrt((mean2_east-mean1_east)^2 + (mean2_north-mean1_north)^2); 


%% Darstellung in Karte
% wm = webmap('World Imagery');
% wmline(data.H1.Position.latitude,data.H1.Position.longitude,'Color','black','FeatureName','H3')
% wm = webmap('World Imagery');
% wmline(data.H2.Position.latitude,data.H2.Position.longitude,'Color','black','FeatureName','H3')
% wm = webmap('World Imagery');
% wmline(data.H3.Position.latitude,data.H3.Position.longitude,'Color','black','FeatureName','H3')
% wm = webmap('World Imagery');
% wmline(data.H4.Position.latitude,data.H4.Position.longitude,'Color','black','FeatureName','H4')
% wm = webmap('World Imagery');
% wmline(data.H5.Position.latitude,data.H5.Position.longitude,'Color','black','FeatureName','H3')


%% Funktionen

function [TT] = loadNMEA(nmeadata,day)
% import daten
fileID = nmeadata;
% Read the text file.
gpsData = fscanf(fileID,'%c');
parserObj = nmeaParser('MessageId','GGA');
% Parse the NMEA Data.
ggaData = parserObj(gpsData);
latitude = zeros(numel(ggaData),1);
longitude = zeros(numel(ggaData),1);
altitude = zeros(numel(ggaData),1);
for i=1:length(ggaData)
    % Check if the parsed GGA sentences are valid and if they are valid, get the
    % latitude and longitude from the output structures. Status = 0,
    % indicates the data is valid
    if ggaData(i).Status == 0
        latitude(i,1) = ggaData(i).Latitude;
        longitude(i,1) = ggaData(i).Longitude;
        altitude(i,1) = ggaData(i).Altitude;
        time(i,1) = day + timeofday(ggaData(i).UTCTime + hours(1));
    end
    if i>=2 && time(i,1) == time(i-1,1)
        latitude(i,1) = NaN;
        longitude(i,1) = NaN;
        altitude(i,1) = NaN;
    end
end
% Remove Nan value in latitude and longitude data, if any nmeaParser object
% returns NaN for a value if the value is not available in the sentence.
% For example, latitude and longitude data are not available if there is no
% satellite fix.
validIndices = ~isnan(latitude) & ~isnan(longitude);
latitude = latitude(validIndices);
longitude = longitude(validIndices);
altitude = altitude(validIndices);
time = time(validIndices);

TT = timetable(time, longitude, latitude, altitude);

% % Plot the position in geographic coordinates
% figure()
% geoplot(latVector,lonVector,'Marker',"*",'MarkerSize',3, ...
% "Color",'blue','MarkerFaceColor','red');
% % Selects the basemap
% geobasemap 'satellite';
% 
% figure()
% sgtitle(name)
% % lontitude plot
% subplot(1, 2, 1);
% plot(timeVector, lonVector, 'b-*');
% xlabel('Time (UTC)');
% ylabel('Longitude');
% title('Longitude vs Time');
% % latitude plot
% subplot(1, 2, 2);
% plot(timeVector, latVector, 'r-*');
% xlabel('Time (UTC)');
% ylabel('Latitude');
% title('Latitude vs Time');

% refLat = latVector(1);
% refLon = lonVector(1);
% enuCoord = zeros(length(latVector), 3);
% for i = 1:length(latVector)
%     [e, n, u] = geodetic2enu(latVector(i), lonVector(i), 0, refLat, refLon, 0, wgs84Ellipsoid());
%     enuCoord(i, :) = [e, n, u];
% end

% % plot ENU
% figure()
% plot(enuCoord(:, 1), enuCoord(:, 2), 'Marker', "*", 'MarkerSize', 3, "Color", 'blue', 'MarkerFaceColor', 'red');
% xlabel('East [m]');
% ylabel('North [m]');
% title('ENU Coordinates');
% subtitle(name)
end