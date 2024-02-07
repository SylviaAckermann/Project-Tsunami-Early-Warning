function [misfit] = okada_fault_fit(okada_params)
%
% [misfit] = okada_fault_fit(okada_params)
%
% evaluates the misfit of an okada solution defined by the
% passed parameters to the slip (and errors) globally defined:
%


global site_neu_posn site_neu_slip site_neu_err 

[dummy,nsites]=size(site_neu_posn);
slip_weights = 1./(site_neu_err.^2);

site_misfit = [];

% find the predicted displacements for each site
for isite = 1:nsites;
    calc_slip = calc_fault_okada(okada_params,site_neu_posn(:,isite));
    slip_misfit(:,isite) = site_neu_slip(:,isite) - calc_slip;
end

% form the mean weighted misfit:
wresids = slip_misfit.*slip_weights./(sum(slip_weights(:)));
misfit = slip_misfit(:).*slip_weights(:)./(sum(slip_weights(:)));
return
