close all;
clearvars;

%% setup rate constants

e = 1.602e-19; % fundamental charge in coulombs
%% set up simulation

ints = linspace(0.1, 1000,5);
for I=ints

    [ks, epsilon, mu_p, mu_n, d] = aj_constants_fun(I);
    dydt = trap_model(I, ks);
    tspan = [0,40e-6];

    y0 = [0;0;0];

    [ts, ys] = ode15s(dydt, tspan, y0);
    
    ne = ys(:,3);
    nt = ys(:,2);
    nx = ys(:,1);
    nh = ne + nt;
    Jsc = e * d * (nh - ne) / epsilon;

    %% Plot results
    subplot(4,1,1)
    plot(ts(:) * 1e6, ys(:,1))
    hold on;

    ylabel("Exciton Concentration")
    xlabel("t (\mu s)")

    subplot(4,1,2)
    plot(ts(:) * 1e6, ys(:,2))
    hold on;

    ylabel("Occupied Trap Concentration")
    xlabel("t (\mu s)")

    subplot(4,2,1)
    plot(ts(:) * 1e6, ys(:,3))
    hold on;

    ylabel("Free Electron Concentration")
    xlabel("t (\mu s)")
    
    subplot(4,2,2)
    plot(ts(:) * 1e6, Jsc)
    hold on;

    ylabel("Current density")
    xlabel("t (\mu s)")

end

subplot(3,1,1)
names = string(ints);
legend(names);
