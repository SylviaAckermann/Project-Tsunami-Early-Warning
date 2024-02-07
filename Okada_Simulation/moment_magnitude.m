function Mw = moment_magnitude(fault_length,fault_width,fault_slip,shear_modulus)
% Mw = moment_magnitude(fault_length,fault_width,fault_slip,shear_modulus)
% 
% with:
% fault_length|width|slip in meters,and shear_modulus in Pa (typically
% 33 GPa for crustal rocks).

M0 = fault_length*fault_width*fault_slip*shear_modulus;     % seismic moment in N.m 
Mw = 2.*(log10(M0))./3-6.07;

% N.B. M0 from seismic catalogs is sometimes recorded in units of dyne-cm.
% In that case the final constant should be 10.7 rather than 6.07

