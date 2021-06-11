function dydt = simple_model()
% A simple equilibrium solar cell model that does not include trapping or external current
%%  see curr_model for a more physically accurate version
% dydt = [dExcitions; dChargeTransport; dFreeCharge]

%% Initialise inputs: dummy, unresearched inputs used here as placeholders
    k1 = 1e10;
    k2 = 1e9;
    
    kd1 = 1e9;
    kd2 = 1e8;
    
    kr2 = 1e7;

    G0 = 2.5171e+37; %generation for incident intensity of 1000 W.m^-2, all other variables same as main.m
%% take derivatives

    function dydt = derivs(t,y)
        Ex = y(1);
        CT = y(2);
        FC = y(3);
        
        dEx = G0 - kd1 * Ex -k1 * Ex;
        dCT = k1 * Ex - kd2 * CT -k2 * CT + kr2 * FC^2;
        dFC = k2 * CT - kr2 * FC^2;
        
        dydt = [dEx; dCT; dFC];
    end

dydt = @derivs;

end

