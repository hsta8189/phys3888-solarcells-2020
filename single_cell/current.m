close all;
clearvars;

%% setup rate constants

e = 1.602e-19; % fundamental charge in coulombs
%% set up simulation

ints = [0.1,1,10,100,1000];
for I=ints

    [ks, epsilon, mu_h, mu_e, d] = aj_constants_fun(I);
    dydt = curr_model(I, ks, epsilon, mu_h, mu_e, d);
    tspan = [0,40e-6];

    y0 = [0;0;0];

    [ts, ys] = ode15s(dydt, tspan, y0);
    
    ne = ys(:,3);
    nt = ys(:,2);
    nx = ys(:,1);
    nh = ne + nt;
    Jsc = e^2 * d * (mu_h* nh + mu_e * ne).* (nh - ne)/ epsilon;

    %% Plot results
    subplot(2,2,1)
    semilogy(ts(:) * 1e6, nx)
    hold on;

    ylabel("Exciton Concentration")
    xlabel("t (\mu s)")

    subplot(2,2,2)
    semilogy(ts(:) * 1e6, nt)
    hold on;

    ylabel("Occupied Trap Concentration")
    xlabel("t (\mu s)")

    subplot(2,2,3)
    semilogy(ts(:) * 1e6, ne)
    hold on;

    ylabel("Free Electron Concentration")
    xlabel("t (\mu s)")
    
    subplot(2,2,4)
    semilogy(ts(:) * 1e6, Jsc)
    hold on;

    ylabel("Current density")
    xlabel("t (\mu s)")

end

subplot(2,2,1)
names = string(ints);
l = legend(names);
title(l, 'Intensity (watts)')
