function dydt = curr_model(I, ks, epsilon, mu_h, mu_e, d)
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
    kdr = ks(3);
    kr = ks(4); %recombination rate
    
    kt = ks(5); %trapping rate
    kdt = ks(6); %detrapping rate
    T = ks(7); % concentration of traps in material
    
    G0 = ks(8); %generation rate
end

e = 1.602e-19;
alpha = 1;
perc_Ne = 0;

%% take derivatives

    function dydt = derivs(~,y)
        Ex = y(1); % concentration of excitons
        TS = y(2); % concentration of total occupied traps
        Ne = y(3); % concentration of free electrons 
        Nh = Ne + TS; % concentration of free holes
        
        Jsc = e^2 * d * (mu_h* Nh + mu_e * Ne) * ( Nh - Ne) / epsilon;
        
        dEx = G0 - kd1 * Ex - k1 * Ex + kr*Ne*Nh - kdr * Ex;
        dTS = kt*(T-TS)*Ne ./ T - kdt*(TS);
        dNe = k1 * Ex - kr * Ne*Nh - kt*(T-TS)*Ne / T  - Jsc / (2 *e * d);
        
        
        dydt = [dEx; dTS; dNe];
    end

dydt = @derivs;

end

