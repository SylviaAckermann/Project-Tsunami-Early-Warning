function [stnum,mn] = stname2num(stnm,reflist,ignorecase)
% STNAME2NUM assigns a station number to a station name
%   according to a reference list. 
%
%   Usage: [stnum,mn] = stname2num(stnm,reflist,ignorecase)
%   
%   Each row of the string matrices stnm and reflist contains a 
%   station name. All names must have the same length (usually
%   4 characters). The reflist defines the relationship
%   between station names and station numbers, in that
%   the ith row of reflist contains the st name associated
%   station number i. Given a series of st names in
%   matrix stnm, the corresponding st numbers are returned
%   in stnum. If a name in stnm cannot be found in the
%   reflist, then the corresponding row of stnum will be
%   set to NaN.  In the event that there are any missing
%   names, scalar mn will be set to the number of missing 
%   names, otherwise it is set to 0 (with one exception).
% 
%   EXAMPLE If  reflist=['VAVA';
%                        'NIUE';
%                        'TGPS']
%   and   stnm=['TGPS';
%               'HNLU']
%  then   stnum=[3;
%               NaN]  and  mn=1
%
%  The * optional * input variable ignorecase determines
%  whether or not to take case into account. By default
%  ignorecase=0, and case is not ignored, in which case
%  'tgpu' will be considered different to 'TGPU'. Set
%  ignorecase to 1 in order to make comparisons ignore
%  case differences.

%  Version 1    5 June 1997     Mike Bevis 

[n1,n2]=size(reflist); 
[n3,n4]=size(stnm);
if n2~=n4
   error('stnm and reflist contain names of different lengths')
end
if nargin==2
   ignorecase=0;
end
if ignorecase==1
   stnm=lower(stnm);
   reflist=lower(reflist);
end
stnum=NaN*ones(n3,1);
for i=1:n3
  for j=1:n1
     if strcmp(stnm(i,:),reflist(j,:))
        stnum(i)=j;
        break
     end
  end
end
mn=sum(isnan(stnum));

   
