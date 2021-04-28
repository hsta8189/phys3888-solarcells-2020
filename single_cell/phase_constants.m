function [ks] = phase_constants(alpha, beta, constants, args)
%%
    % translate alpha and beta into the array ks using the constants
    % sourced from the function constants
    % alpha = kT / kdT
    % beta = k1 / kd1
    
     %% list of constants
    % ks = zeros(1, 7);
    % ks(1) = k1; %exciton dissociation rate
    % ks(2) = kd1; %non-radiative exciton decay
    % ks(3) = kr; %recombination rate
    % 
    % ks(4) = kt; %trapping rate
    % ks(5) = kdt; %detrapping rate
    % ks(6) = T; %concentration of traps in material
    % 
    % ks(7) = G0; %generation rate
    %% body
    % source constants
    if nargin == 3
        ks = constants();
    else
        ks = constants(args(:));      
    end
    
    ks(4) = alpha^(0.5);
    ks(5) = alpha^(-0.5);
    
    ks(1) = beta^(0.5);
    ks(2) = beta^(-0.5);
    
    
    
    
    