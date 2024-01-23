%% Load pos data in Matlab
% datafile = filepath to designated file
function TT = loadpos(datafile)

data = load(datafile);
latitude = data(:,3);
longitude = data(:,4);
height = data(:,5);
Q = data(:,6);
ns = data(:,7);
sdn = data(:,8);

data_t = importdata(datafile);
data_t = data_t(15:end);

for i = 1:length(data_t)
    date_str = convertCharsToStrings(data_t{i}(1:23));
    date(i,:) = datetime(date_str,'InputFormat','yyyy/MM/dd HH:mm:ss.SSS');
end
date = date + hours(1); % Anpassung der Zeit

TT = timetable(date, latitude,longitude,height,Q,ns,sdn);

end