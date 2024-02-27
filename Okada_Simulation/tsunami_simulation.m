close all
clear all

% script to test the calc_okada_displacements function

% Southern Epicenter 
lla0_epicenter = [48.8630556, 9.1344444, 335; 48.7411358, 9.1121643, 429]  %[lat0 lon0 alt0]
epicenter_all = ["Central epicenter", "Southern epicenter"]

slip_parameters = [20 30 40 50];

i = 1;

for e = 1 %1:length(epicenter_all)
    epicenter = epicenter_all(e)
    lla0 = lla0_epicenter(e,:)

for s = 1:length(slip_parameters)

    %% okada_parameters
    okada_params = [];
    okada_params.title = 'demo of the Okada finite rectangular source function'
    % center of the fault:
    okada_params.E = 0.0;
    okada_params.N = 0.0;
    okada_params.depth = 30*1e3;     % X km deep
    % fault orientation:
    okada_params.strike = 0;   % orientation of the trace of the fault
    okada_params.rake = 19; % slip is in the up-dip (i.e. thrust-fault) direction
    okada_params.dip = 100;     %  fault dip below horizon, looking along-strike
    % fault size
    okada_params.length = 20*1e3;    % along the strike
    okada_params.width = 40*1e3;    % perpendicular to the strike
    % slip type/size:
    okada_params.slip = slip_parameters(s);  % 1m of slip
    okada_params.open = 0;
    okada_params.nu = 0.25;

    % calculate magnitue from parameters
    shear_modulus = 33 * 1e9 % for crustal rocks
    magnitude = moment_magnitude(okada_params.length,okada_params.width,okada_params.slip,shear_modulus);
    
    %% Displacement for area of observation points
 
    % now define a bunch of observation points on the surface:
    [E,N] = meshgrid(-25:2.5:25,-25:2.5:25);    % in km for ease
    U = 0*E;
    site_neu = 1000.*[N(:)';E(:)';U(:)'];   % into m to match the rest
    
    % now call the intermediary function:
    okada_params = calc_okada_displacement(okada_params,site_neu);
    
    % and plot the results:
    handles = plot_okada_fault(okada_params);
    figure(handles.figid)
    handles.sites = plot(okada_params.site_neu(2,:),okada_params.site_neu(1,:),'ko');
    
    % need to convert the size of the arrows (probably 10s of cm) we want to
    % plot into map scale (e.g. 10s of km)

    % Vertical displacement
    Updisp = reshape(okada_params.displacement_neu(3,:),size(E));
    handles.vert_disps = contour(1000*E,1000*N,Updisp,-5:.01:5,'-'); %contour(1000*E,1000*N,Updisp,-.5:.01:.5,'-');

    % Horizontal displacement
    vect_scale = 3000; %20000;
    handles.horiz_disps = quiver(okada_params.site_neu(2,:),okada_params.site_neu(1,:),okada_params.displacement_neu(2,:)*vect_scale,okada_params.displacement_neu(1,:)*vect_scale,0,'Color','k');
    handles.horiz_scale_vect = quiver(1000*E(end),1000*mean(N(:)),.1*vect_scale,0,0,'Color','m');
    handles.horiz_scale_label = text(1000*E(end),1000*mean(N(:))-1000,'10 cm');

    handles.colorbar = colorbar;
    handles.colorbar.Label.String = 'Vertical Displacement (m)'

    %% Calculate displacement for measurement locations
    Location = ["Mühlacker", "Rutesheim", "Möglingen", "Bad Canstatt", "Schwaikheim"]';
    lla_muehlacker = [48.9492766 8.8485431 273];    % Mühlacker [lat lon alt]
    lla_rutesheim = [48.8029743 8.9508778 445];     % Rutesheim
    lla_moeglingen = [48.8852232 9.1317666 294];    % Möglingen 
    lla_badCanstatt = [48.8093960 9.2258372 246];   % Bad Canstatt
    lla_schwaikheim = [48.8722200 9.3644180 290];   % Schwaikheim
    lla = [lla_muehlacker; lla_rutesheim; lla_moeglingen; lla_badCanstatt; lla_schwaikheim];

    % convert to local North-East-Down Frame
    xyzNED = lla2ned(lla,lla0,'flat');
    N = xyzNED(:,1);
    E = xyzNED(:,2);
    D = xyzNED(:,3);
    plot(E, N,'.m','MarkerSize',30)
    
    % now call the intermediary function:
    okada_params_neu = calc_okada_displacement(okada_params,[xyzNED(:,1:2) (-1)*xyzNED(:,3)]');
    disp_north = okada_params_neu.displacement_neu(1,:)';
    disp_east = okada_params_neu.displacement_neu(2,:)';
    disp_down = okada_params_neu.displacement_neu(3,:)';

    % calculate distance and azimuth
    Azimut = atan2(disp_north, disp_east)*180/pi;
    Distance = sqrt(disp_north.^2+disp_east.^2);

    % create table
    Epicenter = repmat(epicenter,length(Location),1);
    Slip = repmat(okada_params.slip,length(Location),1);
    Magnitude = repmat(magnitude,length(Location),1);
    displacement{i} = table(Epicenter,Location, Slip, Magnitude, disp_north, disp_east, disp_down, Azimut, Distance);
    
    i = i+1;

end

end



