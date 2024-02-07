function [handles] = plot_okada_fault(okada_params,figid);
%
% [handles] = plot_okada_fault(okada_params,figid);
%
% plots a mapview image of the okada fault plane based on the fault
% geometry given in the okada_params structure

handles=[];

if nargin < 8
    handles.figid = figure;
else
    figure(figid)
    handles.figid = figid;
end

hax = get(gcf,'CurrentAxes');
if isempty(hax)
    handles.axes = axes('Position',[.1 .1 .85 .85]);
else
    handles.axes = hax;
end

hold on
grid on
box on

% create a patch with strike due North at the surface
flatENU = [0.5*okada_params.width*[-1 1 1 -1 -1];0.5*okada_params.length.*[-1 -1 1 1 -1];0*[1 1 1 1 1]]
% rotate about the Y-axis to add the dip:
theta = -okada_params.dip*pi./180;
rotY = [ cos(theta)  0 -sin(theta);0 1 0;sin(theta) 0 cos(theta)];
dipENU = rotY*flatENU;
% and spin about the Z-axis it to the correct strike:
theta = okada_params.strike*pi./180;   % azimuth is opposite to mathematical angle...
rotZ = [cos(theta) sin(theta) 0;-sin(theta) cos(theta) 0;0 0 1];
strikeENU = rotZ*dipENU;

% now put it down at the centroid location (switching depth to -ve Up):
faultENU = strikeENU+[okada_params.E.*ones(1,5);okada_params.N.*ones(1,5);-okada_params.depth.*ones(1,5)];

% simple 2D plot for now:
handles.fault_outline=plot(faultENU(1,:),faultENU(2,:),'k-');
handles.fault_center=plot(okada_params.E,okada_params.N,'ko');
% or a 3D plot:
% handles.fault_patch=patch(faultENU(1,:),faultENU(2,:),faultENU(3,:),[1 1 1]);
% handles.fault_center=plot3(okada_params.E,okada_params.N,-okada_params.depth,'ko');

handles.xlabel = xlabel('E (m)');
handles.ylabel = ylabel('N (m)');
% handles.zlabel = zlabel('U (m)');

axis('equal')
