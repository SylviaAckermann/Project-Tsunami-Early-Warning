% ------------------------------------------------------------------------
% This script calculates the Okada parameters and earthquake magnitude 
% from measured displacements
% ------------------------------------------------------------------------

close all

%% Define Earthquake Scenario
scenario = 3;

%% Import Simulation Parameters 
okada_params = [];

% Okada Parameters: E, N
lla0_epicenter = [48.8630556, 9.1344444, 335; 48.7411358, 9.1121643, 429];  %[lat0 lon0 alt0]
epicenter_all = ["Central epicenter", "Southern epicenter"];

if scenario == 1
    epicenterIdx = 1;
elseif sum(scenario == [2:5]) == 1
    epicenterIdx = 2;
end

epicenter = epicenter_all(epicenterIdx);
lat0 = lla0_epicenter(epicenterIdx,1);
lon0 = lla0_epicenter(epicenterIdx,2);
okada_params.E = 0;
okada_params.N = 0;

% Okada Parameter slip
slip_parameters = [50 50 40 30 20];
okada_params.slip = slip_parameters(scenario);

% Fixed Okada Parameters
okada_params.depth = 30;     % X km deep
% fault orientation:
okada_params.strike = 0;   % orientation of the trace of the fault
okada_params.rake = 19; % slip is in the up-dip (i.e. thrust-fault) direction
okada_params.dip = 100;     %  fault dip below horizon, looking along-strike
% fault size
okada_params.length = 20;    % [km] along the strike
okada_params.width = 40;    % [km] perpendicular to the strike

% slip type/size:
okada_params.open = 0;
okada_params.nu = 0.25;

% calculate magnitue from parameters
shear_modulus = 33 * 1e9; % for crustal rocks
magnitude_true = moment_magnitude(okada_params.length*1e3,okada_params.width*1e3,okada_params.slip,shear_modulus);
    
%% Okada Parameters
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

% Fixed parameters: depth, strike, dip (couple of meters/degrees)
% Parameters with small intervall: E, N (determinded from seismographic
% data)
% Parameters to determine: fault_length, fault_width, slip (huge intervall)

%                 E , N,   depth, strike, dip, fault_length, fault_width, slip
okada_start = [  500,   4000,   30,  0,     100,     10,       10,    30];
upper_bounds = [ 1000   6000   30   0      100      50        50    100];
lower_bounds = [0  4000   30   0      100       1         1     10];


rand_vect = rand(1,length(upper_bounds));
okada_params_true = okada_params;

%% Calculate Epicenter

% need the East-North-Up locations of each observation point, and the
% E-N-U displacements at those points:
data = ["C50","S50","S40","S30","S20"];
offsetts = read_offsets(["Verschiebungen/displacement"+data(scenario)+".dat"]);
%offsetts = offsetts(1:3);
% load vstack_BIGAMY_seasonals_stepped_rtv.mat
load rtv.mat
nsites = length(offsetts);

% I keep everything all together in structures - but not needed...
slipts = [];

for isite = 1:nsites
    slipts.stnm(isite,:)=offsetts(isite).site;
    slipts.neu_slip(isite,:)=offsetts(isite).neu_offset;
    slipts.neu_err(isite,:)=[0.003 0.003 0.005];%[.0005 .0005 .0015];
end

is = stname2num(slipts.stnm,rtv.stnm)
slipts.latlonelev = [rtv.lat(is) rtv.lon(is) rtv.elev(is)];

isites = 1:nsites;

% this passes the key data down to the next level of Matlab functions:
global site_neu_posn site_neu_slip site_neu_err 


site_neu_slip = slipts.neu_slip(isites,:)'*1000;
site_neu_err = slipts.neu_err(isites,:)'*1000;
[this_x,this_y] = d2u(slipts.latlonelev(isites,2),slipts.latlonelev(isites,1));
[x0,y0] = d2u(lon0,lat0);
x0 = x0*1e-3;
y0 = y0*1e-3;
site_neu_posn = [this_y';this_x';slipts.latlonelev(isites,3)']./1000;

% solve for the best fitting Okada fault based on a non-linear inversion
% over the parameter ranges given:
[okada_params,resnorm,residual,exitflag] =  lsqnonlin('okada_fault_fit',okada_start,lower_bounds,upper_bounds);

okada_struct.E =okada_params(1);       
okada_struct.N =okada_params(2);
okada_struct.depth =okada_params(3);
okada_struct.strike=okada_params(4);
okada_struct.dip =okada_params(5);
okada_struct.length =okada_params(6);
okada_struct.width =okada_params(7);
okada_struct.slip =okada_params(8);

% plot the fault plane for this solution:
%[hhandles] = plot_okada_fault(okada_struct);

% calculate the displacements this fault solution predicts
nsites = size(site_neu_posn,2);
for is = 1:nsites
    calc_slip(:,is) = calc_fault_okada(okada_params,site_neu_posn(:,is));
end

[site_neu_slip' calc_slip']

magnitude_calc = moment_magnitude(okada_struct.length*1e3,okada_struct.width*1e3,okada_struct.slip,shear_modulus);
%%

% Calculated Parameters
disp('Okada parameters fault calculation:')
T_okada_calc = table(okada_params(1),okada_params(2), okada_params(3), okada_params(4),...
    okada_params(5), okada_params(6), okada_params(7), okada_params(8), magnitude_calc,...
    'VariableNames', {'E[m]', 'N[m]', 'depth[km]', 'strike[°]', 'dip[°]', 'length[km]', 'width[km]', 'slip[m]', 'magnitude'});
disp(T_okada_calc);

% True Parameters
disp('True Okada parameters of earthquake simulation:')
T_okada_true = table(x0, y0, okada_params_true.depth,okada_params_true.strike, okada_params_true.dip,...
                     okada_params_true.length, okada_params_true.width, okada_params_true.slip, magnitude_true,...
    'VariableNames', {'E[m]', 'N[m]', 'depth[km]', 'strike[°]', 'dip[°]', 'length[km]', 'width[km]', 'slip[m]', 'magnitude'});
disp(T_okada_true);
