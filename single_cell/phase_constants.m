function [ks] = phase_constants(alpha, beta, ks)
%%
    % translate alpha and beta into the array ks using the constants
    % sourced from the function constants
    % alpha = kT / kdT
    % beta = k1 / kr
    
     %% list of constants
%     ks = zeros(1, 7);
%     ks(1) = k1; %exciton dissociation rate
%     ks(2) = kd1; %non-radiative exciton decay
%     ks(3) = kdr;
%     ks(4) = kr; %recombination rate
% 
%     ks(5) = kt; %trapping rate
%     ks(6) = kdt; %detrapping rate
%     ks(7) = T; %concentration of traps in material
% 
%     ks(8) = G0; %generation rate
    %% body
    % source constants

    ks(5) = alpha^(0.5);
    ks(6) = alpha^(-0.5);
    
    ks(1) = beta^(0.5);
    ks(4) = beta^(-0.5);
    
    
    
    
    