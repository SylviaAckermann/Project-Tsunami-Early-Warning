
x0 = 263610;
y0 = 2147100;

% okada parameters are:
% okada_params:  E , N, depth, strike, dip, fault_length, fault_width,      ,slip
%                1   2    3       4     5        6             7               8
% okada85 wants: E , N, depth, strike, dip, fault_length, fault_width, rake ,slip ,opening ,nu
%
% but we'll fix rake, and opening to 0  so the free parameters are:
%
%
% Locations/lengths in km, displacements/slips in mm
%
% define the upper and lower bounds for those parameters we want to
% constrain the range of:

%                 E , N, depth, strike, dip, fault_length, fault_width,      ,slip
upper_bounds = [ 30   10   12      90    10       60            60            8000];
lower_bounds = [-30  -40    2       0   -10        0             0              0];
okada_start  = [ 20  -10    5      10     0       30            20            1000];

rand_vect = rand(1,length(upper_bounds));


% need the East-North-Up locations of each observation point, and the
% E-N-U displacements at those points:
offsetts = read_offsets('20180504_M6_9.dat');
load vstack_BIGAMY_seasonals_stepped_rtv.mat
nsites = length(offsetts);

% I keep everything all together in structures - but not needed...
slipts = [];

for isite = 1:nsites
    slipts.stnm(isite,:)=offsetts(isite).site;
    slipts.neu_slip(isite,:)=offsetts(isite).neu_offset;
    slipts.neu_err(isite,:)=[.0005 .0005 .0015];
end

is = stname2num(slipts.stnm,rtv.stnm)
slipts.latlonelev = [rtv.lat(is) rtv.lon(is) rtv.elev(is)];

isites = 1:nsites;

% this passes the key data down to the next level of Matlab functions:
global site_neu_posn site_neu_slip site_neu_err 


site_neu_slip = slipts.neu_slip(isites,:)'*1000;
site_neu_err = slipts.neu_err(isites,:)'*1000;
[this_x,this_y] = d2u(slipts.latlonelev(isites,2),slipts.latlonelev(isites,1));
site_neu_posn = [this_y'-y0;this_x'-x0;slipts.latlonelev(isites,3)']./1000;

% solve for the best fitting Okada fault based on a non-linear inversion
% over the parameter ranges given:
[okada_params,resnorm,residual,exitflag] =  lsqnonlin('okada_fault_fit',okada_start,lower_bounds,upper_bounds);

% plot the fault plane for this solution:
[hhandles,vhandles] = plot_fault_okada(okada_params);

% calculate the displacements this fault solution predicts
nsites = size(site_neu_posn,2);
for is = 1:nsites
    calc_slip(:,is) = calc_fault_okada(okada_params,site_neu_posn(:,is));
end



%        E ,       N,      depth,  strike,      dip,   length,    width,  ,slip
%    18.8844  -10.0000    3.5140   50.0000    2.7679   50.0000   34.3075  445.7623
%   25.0632  -24.5441    2.0000   51.1236    0.4174   39.6421   60.0000  600.0000
disp(['    E ,      N,   depth, strike,  dip, length, width, slip'])
okada_str = sprintf(' %6.2f   %6.2f  %5.2f  %5.1f   %4.1f  %5.1f  %5.1f  %6.1f\n',okada_params);
disp(okada_str)


[site_neu_slip' calc_slip']
