%% Load pos data in Matlab
% datafile = filepath to designated file
function sattable = loadpos(datafile)

data = load(datafile);
datat = importdata(datafile);
datat = datat(15:end);

for i = 1:length(datat)
    datestr = convertCharsToStrings(datat{i}(1:23));
    sattable.date(i,:) = datetime(datestr,'InputFormat','yyyy/MM/dd HH:mm:ss.SSS');
    sattable.data(i,:) = data(i,3:end);
end

end