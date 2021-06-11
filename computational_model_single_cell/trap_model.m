function dydt = trap_model(ks)
% Single-cell model,
% Includes trap states, excludes charge transfer and radiative FC, excludes current flow, recombination and exciton decay
%%  see curr_model for a more physically accurate version
% dydt = [dExcitons; dTrapState; dElectrons]

%% Initialise inputs
if nargin < 1
    k1 = 1e10;
    
    kd1 = 1e7;
    
    kr = 1e7;
    
    kt = 1e5;
    kdt = 1e5;
    T = 1e22; 
    G0 = 2.5171e+37; %generation for incident intensity of 1000 W.m^-2, all other variables same as main.m

else
    k1 = ks(1); %exciton dissociation rate
    kd1 = ks(2); %non-radiative exciton decay
    kdr = ks(3);
    kr = ks(4); %recombination rate
    
    kt = ks(5); %trapping rate
    kdt = ks(6); %detrapping rate
    T = ks(7); % concentration of traps in material
    
    G0 = ks(8); %generation rate
end




%% take derivatives

    function dydt = derivs(t,y)
        Ex = y(1); % concentration of excitons
        TS = y(2); % concentration of total occupied traps
        Ne = y(3); % concentration of free electrons 
        Nh = Ne + TS; % concentration of free holes
        
        dEx = G0 - kd1 * Ex - k1 * Ex + kr*Ne*Nh - kdr * Ex;
        dTS = kt*(T-TS)*Ne - kdt*(TS);
        dFC = k1 * Ex - kr * Ne*Nh - dTS;
        
        
        dydt = [dEx; dTS; dFC];
    end

dydt = @derivs;

end

