close all;
clearvars;

%% setup rate constants
run constants.m

%% set up simulation

ints = linspace(0.1, 1000,5);
for I=ints

    dydt = simple_model(I, G0, ks);
    tspan = [0,2];

    y0 = [0;0;0];

    [ts, ys] = ode15s(dydt, tspan, y0);

    %% Plot results
    subplot(3,1,1)
    plot(ts(:), ys(:,1))
    hold on;

    ylabel("Exciton Concentration")
    xlabel("t (microseconds)")

    subplot(3,1,2)
    plot(ts(:), ys(:,2))
    hold on;

    ylabel("CT Concentration")
    xlabel("t (microseconds)")

    subplot(3,1,3)
    plot(ts(:), ys(:,3))
    hold on;

    ylabel("FC Concentration")
    xlabel("t (microseconds)")

end

subplot(3,1,1)
names = string(ints);
legend(names);
