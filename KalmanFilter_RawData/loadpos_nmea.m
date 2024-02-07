%% Load pos data in Matlab
% datafile = filepath to designated file
function TT = loadpos_nmea(filename)

% input data
fid = fopen(filename,'r');
% Read the text file.
gpsData = fscanf(fid,'%c');
parserObj = nmeaParser('MessageId','GGA');
% Parse the NMEA Data.
ggaData = parserObj(gpsData);
latitude = zeros(numel(ggaData)/2,1);
longitude = zeros(numel(ggaData)/2,1);
height = zeros(numel(ggaData)/2,1);

% Check if the parsed GGA sentences are valid and if they are valid, get the
% latitude and longitude from the output structures. Status = 0,
% indicates the data is valid
j = 1;
time_previous = datetime('now','TimeZone','local');
for i = 1:length(ggaData)
    if ggaData(i).Status == 0
        time_current = ggaData(i).UTCTime
        if time_current ~= time_previous
            latitude(j) = ggaData(i).Latitude;
            longitude(j) = ggaData(i).Longitude;
            height(j) = ggaData(i).Altitude;
            date(j) = time_current;
            time_previous = time_current;
            j = j+1;
        end
    end
end

TT = timetable(date, latitude,longitude,height);

end