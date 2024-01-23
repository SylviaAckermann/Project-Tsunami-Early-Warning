function okada_params = calc_okada_displacement(okada_params,site_neu)
%
% okada_params = calc_okada_displacement(okada_params,site_neu)
%
% calc_okada_slip takes a structure containing all the required parameters
% for a rectangular slip dislocation, and a second set of site locations
% (where all locations are in the same East-North-Up coordinate system) and
% returns the displacement vectors calculated by the Okada85 function as a 
% new field in the okada params which the site NEU coordinates also added.
%
% input:
%   okada_params    structure with the following fields: E, N, depth, strike, 
%                   dip,fault_length, fault_width, rake ,slip ,opening ,nu
%                   (E,N,depth gives the locations of the fault centroid;
%                   only one of slip|opening should be provided; nu -
%                   Poissons ratio - is normally set to 0.25)
%
%   site_neu        set of N-E-U triplets for each site for which
%                   displacements should be calculated. site = 3 x n
%
% output:
%
% okada_params      as above but with site_neu and displacement_neu (3 x n)
%                   fields appended
%

okada_params.site_neu = site_neu;

[uE,uN,uZ,uZE,uZN,uNN,uNE,uEN,uEE] = okada85(okada_params.site_neu(2,:)-okada_params.E,okada_params.site_neu(1,:)-okada_params.N,okada_params.site_neu(3,:)+okada_params.depth,...
    okada_params.strike, okada_params.dip, okada_params.length, okada_params.width, okada_params.rake ,okada_params.slip, okada_params.open, okada_params.nu);

% add the topographic perturbation corrections:

disps = [uN;uE;uZ];

okada_params.displacement_neu = disps;


