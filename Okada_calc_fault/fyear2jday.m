	function [outdate1,outdate2] = fyear2jday(indate1,indate2);
%
% usage: [jday,yr] = fyear2jday(fyear);
%		   or
% usage:   [fyear] = fyear2jday(jday,yr);
%
%
% simple function to return the Julian Day and Year
% from a vector of Fractional/Floating-Point Years.
% or vice versa.
%

 
% James Apr 98


if nargin < 1 | nargin > 2
 disp('Enter ''fyear'' to get Julian Day and Year.');
 disp('Enter ''jday'' & ''yr'' Fractional Year.');
 return;
end


if nargin == 1		% should be fyear

 yr = [];
 jday = [];
 fyear = indate1(:);
 outdate1=NaN.*ones(length(fyear),1);
 outdate2=outdate1;

 year = floor(fyear);
 daysinyr = 365*ones(length(fyear),1);
 daysinyr(mod(year,4)==0)=366;

 fdoy = (fyear-year).*daysinyr+1;

 outdate1=fdoy;
 outdate2=year;
 
elseif nargin == 2	% should be [jday, yr]

 jday = indate1;
 if indate2 < 100
   yr = indate2;
   year = 1900+yr;
   if (year<1980)
     year=year+100;
   end
 else
   year = indate2;
  end
 if (length(jday) ~= length(year)) 
   if length(year) ~= 1
     error('jday and year must be either same size, or year a scalar');
   end
 end

 fyear = [];
 outdate=NaN.*ones(size(jday));

 daysinyr = 365.*ones(size(year));
 daysinyr(mod(year,4)==0)=366;
 fyear = year + (jday-1)./daysinyr;
 outdate1=fyear;

end
