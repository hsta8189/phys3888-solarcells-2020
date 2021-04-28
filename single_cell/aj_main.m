close all;
clearvars;

%% set up simulation and rate constants

ints = linspace(0.1,1000,5);
for I=ints
    ks = aj_constants_fun(I);
    dydt = aj_simple_model(I, ks);
    tspan = [0,1];

    y0 = [0;0;0];

    [ts, ys] = ode15s(dydt, tspan, y0);

    %% Plot results
    subplot(3,1,1)
    plot(ts(:), ys(:,1))
    hold on;

    ylabel("Exciton Concentration (m^-3)")
    xlabel("t (s)")

    subplot(3,1,2)
    plot(ts(:), ys(:,2))
    hold on;

    ylabel("Trap state occupation (m^-3)")
    xlabel("t (s)")

    subplot(3,1,3)
    plot(ts(:), ys(:,3))
    hold on;

    ylabel("FC Concentration (m^-3)")
    xlabel("t (s)")

end

subplot(3,1,1)
names = string(ints);
legend(names);
