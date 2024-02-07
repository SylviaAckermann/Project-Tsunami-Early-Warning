function calc_slip = calc_fault_okada(okada_params,site_neu);
%
% 
% okada_params:  E , N, depth, strike, dip, fault_length, fault_width,      ,slip
%                1   2    3       4     5        6             7               8
% okada85 wants: E , N, depth, strike, dip, fault_length, fault_width, rake ,slip ,opening ,nu


[uE,uN,uZ,uZE,uZN,uNN,uNE,uEN,uEE] = okada85(site_neu(2)-okada_params(1),site_neu(1)-okada_params(2),site_neu(3)+okada_params(3),...
    okada_params(4), okada_params(5), okada_params(6), okada_params(7), -90 ,okada_params(8), 0, 0.25);

% gather the predicted displacements into a vector:
calc_slip = [uN;uE;uZ];
