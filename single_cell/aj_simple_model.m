function dydt = aj_simple_model(I,ks)
% Single-cell model, Alice's modified version
%   
% dydt = [dExcitons; dTrapState; dFreeCharge]

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
    T = ks(6); %concentration of traps in material
    
    G0 = ks(7); %generation rate
end


%% take derivatives

    function dydt = derivs(t,y)
        Ex = y(1);
        TS = y(2);
        FC = y(3);       
        
        dEx = G0*t - kd1 * Ex -k1 * Ex;
        dTS = kt*(T-TS)*FC - kdt*(TS^2 + TS*FC);
        dFC = k1 * Ex - kr * FC^2 - kt*Ex + kdt*Ex;
        
        dydt = [dEx; dTS; dFC];
    end

dydt = @derivs;

end

