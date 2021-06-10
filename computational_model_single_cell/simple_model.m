function dydt = simple_model(I,G0,ks)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% dydt = [dExcitions; dChargeTransport; dFreeCharge]

%% Initialise inputs
if nargin <= 2
    k1 = 1e10;
    k2 = 1e9;
    
    kd1 = 1e9;
    kd2 = 1e8;
    
    kr2 = 1e7;
else
    
    k1 = ks(1);
    k2 = ks(2);
    
    kd1 = ks(3);
    kd2 = ks(4);
    
    kr2 = ks(5);
    ends


%% take derivatives

    function dydt = derivs(t,y)
        Ex = y(1);
        CT = y(2);
        FC = y(3);
        
        dEx = G0 * I -kd1 * Ex -k1 * Ex;
        dCT = k1 * Ex - kd2 * CT -k2 * CT + kr2 * FC^2;
        dFC = k2 * CT - kr2 * FC^2;
        
        dydt = [dEx; dCT; dFC];
    end

dydt = @derivs;

end

