function [offsetts] = read_offsets(offsetfile);
%
% [offsetts] = read_offsets(offsetfile);
%
% read_offsets reads in the (SOPAC) offsets file and converts
% it into a matlab structure.
%
% input:
%   offsetfile  (full) filename for the text file of offsets.
%               format is expected as: 
%                 SITE YEAR MN DY HR MN SC dNorth dEast dUp [dN_post dE_post dU_post tau_post] Comment
%               where the Comment is optional
%
% output:
%   offsetts    matlab structure containing the offsets, organised
%               by site. Fields are:
%       site
%       year
%       fyear
%       doy
%       fdoy
%       neu_offset
%       comment
%       [post_seismic_neu   post-seismic deformation magnitude] 
%       [post_seismic_tau   post-seismic relaxation time]

%%%--- set up the empty arrays:

stnm = [];
lno=0;
nst=0;

[fid,message] = fopen(offsetfile,'r');
if ~isempty(message) | fid == -1
   disp(['read_offsets: cannot open offset file ',offsetfile])
   disp(message)
   return
end

while 1
  line=fgetl(fid); 
  lno=lno+1;                      % increment line no.
  if ~isstr(line), break, end     % break at EOF
  
  nl=length(line);
  
  if nl>=4   % if this is a site offset line
    [name,cnt,err1,nxt]=sscanf(line,'%4s',1);       % site name should be first 4 chars:
    strt=nxt;
    
    if ~isempty(stnm)
      [stnum,mn] = stname2num(name,stnm,1);    % is this station already in stnm list?
    else
      stnum=1;
      mn=1;
    end

    if mn==0      % if stn matches on in the stnm filter we already have it: append this offset
      isite = stnum;
      [noffsets,ncomps] = size(offsetts(isite).neu_offset);
      ioffset = noffsets+1;
    else                    % we didn't find this site already in the structure: add it as new
      nst=nst+1;
      isite = nst;
      ioffset = 1;
      offsetts(isite).site = name;
      stnm=[stnm;name];
    end
    
    [ndata,cnt,err2,nxt]=sscanf(line(strt+1:nl),'%f',6);    % site name should be followed by 6 date-time numbers:
    if ~isempty(err2)
      error(['could not parse offset file ',offsetfile,' line # ',int2str(lno)])
    end
    if cnt~=6
      error(['could not parse offset file ',offsetfile,' line # ',int2str(lno)])
    end
      
% parse the numbers into date & time + NEU offset:
    year = ndata(1);
    month = ndata(2);
    day = ndata(3);
    hour = ndata(4); minute = ndata(5); seconds = ndata(6);
    doy = jul2date(day,month,year);
    fdoy = doy + (hour + (minute + seconds/60)./60)./24;
    fyear = fyear2jday(fdoy,year);
    
    offsetts(isite).year(ioffset,1)=year;
    offsetts(isite).fyear(ioffset,1)=fyear;
    offsetts(isite).doy(ioffset,1)=doy;
    offsetts(isite).fdoy(ioffset,1)=fdoy;
    
    
%    [ndata,cnt,err2,nxt2]=sscanf(line(nxt+strt+1:nl),'%f',3);    % date-time numbers should be followed by N E U offsets:

    
    % variable format: could be additional post-seismic (exp function) parameters (4 floating point numbers) 
    % or simply the comment string... (comment must start with characters
    % otherwise this read will fail...
    [ndata,cnt,err2,nxt2]=sscanf(line(nxt+strt+1:nl),'%f');    %  N E U offsets could be followed by post-seismic parameters
    
   % disp(['Found ',int2str(cnt),' offset parameters for ',name])
    neu_offset = ndata(1:3);
    offsetts(isite).neu_offset(ioffset,1:3)=neu_offset;
    % if we found 7 numbers we've got post-seismic info:
    if cnt == 7
      offsetts(isite).post_seismic_neu(ioffset,1:3) = ndata(4:6);
      offsetts(isite).post_seismic_tau(ioffset) = ndata(7);
    else
       offsetts(isite).post_seismic_neu(ioffset,1:3) = [NaN NaN NaN];
      offsetts(isite).post_seismic_tau(ioffset) = NaN;
       
    end
    % everything from the point we hit a character should be comment:
    offsetts(isite).comment(ioffset,1)={line(nxt+strt+nxt2:nl)};  
  end  
end
fclose(fid);
