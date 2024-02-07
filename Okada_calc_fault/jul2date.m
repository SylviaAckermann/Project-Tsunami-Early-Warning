function	[outdate1,outdate2,outdate3] = jul2date(indate1,indate2,indate3);

%
% function	[outdate1,outdate2,outdate3] = jul2date(indate1,indate2,indate3);
%
%		jul2date transorms between various different date formats: 
%
%	1) input DD, MM, YY to get Julian Day and Year 
%	2) input DD, Mon, YY to get Julian Day and Year
%	3) input JDay, Year to get DD, MM, YY
%
% eg. jul2date(23,10,97) returns 296 1997
%     jul2date(32,2000)
%
%
%

% initialise arguments:
outdate1=[];outdate2=[];outdate3=[];
months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
daysinmonth = [31 28 31 30 31 30 31 31 30 31 30 31];
cumdaysofyr = cumsum([0 daysinmonth]);

if nargin == 3
  
  DD = indate1;
  YY = indate3;
  
   if isstr(indate2(1))
      % option 2) - assume this is a month string:
      for i =1:length(indate1)
        MM(i) = strmatch(indate2(i,:),months);
      end
   else
     MM=indate2;
   end

   if (indate3(1)<100)
     year = indate3 + 1900;
     YY = indate3;
     year(year<1980)=year(year<1980)+100;
   else
    year = indate3;
    YY = mod(year,100);
   end
   
   
   doy = cumdaysofyr(MM)' + DD;
   doy(MM>2 & mod(year,4)==0) = doy(MM>2 & mod(year,4)==0)+1;
   outdate1=doy;outdate2=year;


elseif nargin == 2	% assume doy and year/yr


   doy=indate1;

%% handle either 2-digit or 4-digit year:(?)
   if (indate2(1)<1900)
     year = indate2+1900;
     if (year(1) < 1980)
       year = year+100;
     end
   else
     year = indate2;
   end

   [n,m]=size(doy);
   [o,p]=size(year);
   doy=doy(:)';		% make doy into a row vector
   year=year(:)';	%

   if (length(doy) ~= length(year))
     if (length(year)==1)
       year=year.*ones(size(doy));
     else
       error('Year must be same size as doy (or 1 x 1)');
     end
   end

   daymat = repmat([0;daysinmonth'],1,length(doy));

   YY = year - 1900;
   YY(YY>99)=YY(YY>99)-100;
   leap=0.*ones(1,length(doy));
   leap(mod(YY,4)==0)=1;
   daymat(3,:)=daymat(3,:)+leap;
   cumdays=cumsum(daymat);
   reldays = cumdays-repmat(doy,13,1);
   lomat=reldays;
   lomat(lomat>0)=NaN;
   [dom,ilo]=nanmax(lomat);
   ilo(dom==0)=ilo(dom==0)-1;
   dom(dom==0)=-daymat(ilo(dom==0)+1);
   DD=-dom;
   MM=ilo;
   
   outdate1=reshape(DD,n,m);outdate2=reshape(MM,n,m);outdate3=reshape(YY,n,m);
end
