close all;
clearvars;

%% setup rate constants

e = 1.602e-19; % fundamental charge in coulombs
%% set up simulation

ints = linspace(0.1, 1000,5);
for I=ints

    [ks, epsilon, mu_p, mu_e, d] = aj_constants_fun(I);
    dydt = curr_model(I, ks);
    tspan = [0,40e-6];

    y0 = [0;0;0];

    [ts, ys] = ode15s(dydt, tspan, y0);
    

    %% Plot results
    subplot(3,1,1)
    plot(ts(:) * 1e6, ys(:,1))
    hold on;

    ylabel("Exciton Concentration")
    xlabel("t (\mu s)")

    subplot(3,1,2)
    plot(ts(:) * 1e6, ys(:,2))
    hold on;

    ylabel("Occupied Trap Concentration")
    xlabel("t (\mu s)")

    subplot(3,1,3)
    plot(ts(:) * 1e6, ys(:,3))
    hold on;

    ylabel("Free Electron Concentration")
    xlabel("t (\mu s)")
    

end

subplot(3,1,1)
names = string(ints);
legend(names);
