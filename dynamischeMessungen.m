%% dynamische Position aus rtklib.pos

clear all
close all
clc

% Positionsdaten 
H1 = loadpos('12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_30_50_H1.pos');
H2 = loadpos('12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_30_11_H2.pos');
%H3 = loadpos('5.12.23\Rohdaten_51223\');
H4 = loadpos('12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_22_57_H4.pos');
H5 = loadpos('12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_29_19_H5.pos');
H6 = loadpos('12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_22_41_H6.pos');
H7 = loadpos('12.12.2023\Rohdaten_121223\gnss_log_2023_12_12_10_28_52_H7.pos');

handys = {'H1','H2','H4','H5','H6','H7'}


for i = 1:length(handys)

handy = handys{i};

switch handy
    case 'H1'
        data = H1.data;
        date = H1.date;
    case 'H2'
        data = H2.data;
        date = H2.date;
    case 'H3'
        data = H3.data;
        date = H3.date;
    case 'H4'
        data = H4.data;
        date = H4.date;
    case 'H5'
        data = H5.data;
        date = H5.date;
    case 'H6'
        data = H6.data;
        date = H6.date;
    case 'H7'
        data = H7.data;
        date = H7.date;
end

[data,B] = rmoutliers(data(:,1:3));

date = date(B~=1);

lat = data(:,1);
lon = data(:,2);
u =  data(:,3);

% Umrechnung in enu-System
% Approximation 'flat' -> laut Matlab höhere Genauigkeiten über kurze
% Distanzen
lla0 = [48.779703 9.172573 320]; % [lat0 lon0 alt0] Ursprung für lokales Koordinatensystem

ENU = lla2enu([lat, lon, u], lla0, 'flat');
east = ENU(:,1);
north = ENU(:,2);
up = ENU(:,3);

% Mittelwert aus n Werten
n = 30;
datemean = date(1:(end-30));
for j = 1:(length(east)-n)
meaneast(j) = mean(east(j:(j+n),:));
meannorth(j) = mean(north(j:(j+n),:));
meanup(j) = mean(up(j:(j+n),:));
end

%% Plot
%Zeitpunkte
    points = [datetime('12-Dec-2023 09:45:00.000');
              datetime('12-Dec-2023 09:55:00.000');
              datetime('12-Dec-2023 10:10:00.000');
              datetime('12-Dec-2023 10:20:00.000');
              datetime('12-Dec-2023 10:35:00.000')];


figure
t = tiledlayout(2,2);
title(t,handy)
nexttile
plot(date,east);hold on;
plot(datemean,meaneast,'r');
xline(points,'--',{'1','2','3','4','5'})
ylabel('[m]');xlabel('Time');
title('Position in East')
nexttile
plot(date,north);hold on;
plot(datemean,meannorth,'r');
xline(points,'--',{'1','2','3','4','5'})
ylabel('[m]');xlabel('Time');
title('Position in North')
nexttile
plot(date,up);hold on;
plot(datemean,meanup,'r');
xline(points,'--',{'1','2','3','4','5'})
ylabel('[m]');xlabel('Time');
title('Position in Up')
nexttile
scatter(east,north,'x');hold on;
scatter(meaneast,meannorth,'x','r')
ylabel('[m]');xlabel('[m]');
title('Position in East, North')

clear meaneast
clear meannorth
clear meanup
end

