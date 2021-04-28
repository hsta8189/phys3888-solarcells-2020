function dydt = trap_model(I,ks)
% Single-cell model,
% Includes trap states, excludes charge transfer and radiative FC
% recombinaion and exciton decay
% dydt = [dExcitons; dTrapState; dElectrons]

%% Initialise inputs
if nargin <= 1
    k1 = 1e10;
    
    kd1 = 1e7;
    
    kr = 1e7;
    
    kt = 1e5;
    kdt = 1e5;
    T = 1e22; 
    
else
    k1 = ks(1); %exciton dissociation rate
    kd1 = ks(2); %non-radiative exciton decay
    kr = ks(3); %recombination rate
    
    kt = ks(4); %trapping rate
    kdt = ks(5); %detrapping rate
    T = ks(6); % concentration of traps in material
    
    G0 = ks(7); %generation rate
end

kdr = 10^9; % radiative recombination of excitons


%% take derivatives

    function dydt = derivs(t,y)
        Ex = y(1); % concentration of excitons
        TS = y(2); % concentration of total occupied traps
        Ne = y(3); % concentration of free electrons 
        Nh = Ne + TS; % concentration of free holes
        
        dEx = G0 - kd1 * Ex - k1 * Ex + kr*Ne*Nh - kdr * Ex;
        dTS = kt*(T-TS)*Ne - kdt*(Ne);
        dFC = k1 * Ex - kr * Ne*Nh - dTS;
        
        
        dydt = [dEx; dTS; dFC];
    end

dydt = @derivs;

end
