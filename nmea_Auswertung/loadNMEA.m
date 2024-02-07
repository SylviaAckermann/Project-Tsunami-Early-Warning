function [TT] = loadNMEA(nmeadata,day,name)
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

%% Plot the position in geographic coordinates
figure()
geoplot(latitude,longitude,'Marker',"*",'MarkerSize',3, ...
"Color",'blue','MarkerFaceColor','red');
% Selects the basemap
geobasemap 'satellite';

figure()
sgtitle(name)
% lontitude plot
subplot(1, 2, 1);
plot(time, longitude, 'b-*');
xlabel('Time (UTC)');
ylabel('Longitude');
title('Longitude vs Time');
% latitude plot
subplot(1, 2, 2);
plot(time, latitude, 'r-*');
xlabel('Time (UTC)');
ylabel('Latitude');
title('Latitude vs Time');

refLat = latitude(1);
refLon = longitude(1);
enuCoord = zeros(length(latitude), 3);
for i = 1:length(latitude)
    [e, n, u] = geodetic2enu(latitude(i), longitude(i), 0, refLat, refLon, 0, wgs84Ellipsoid());
    enuCoord(i, :) = [e, n, u];
end

% plot ENU
figure()
plot(enuCoord(:, 1), enuCoord(:, 2), 'Marker', "*", 'MarkerSize', 3, "Color", 'blue', 'MarkerFaceColor', 'red');
xlabel('East [m]');
ylabel('North [m]');
title('ENU Coordinates');
subtitle(name)