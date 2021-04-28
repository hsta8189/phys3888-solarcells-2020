%function results = phase_diagram(model, I, nvars, plot_time_series)
%% set up simulation and rate constants
if true %nargin == 0
    model = 'simple_traps';
    I = 1;
    nvars = 10;
    plot_time_series = false;
elseif nargin == 1
    I = 1;
    nvars = 10;
    plot_time_series = false;
    
elseif nargin == 2
    nvars = 10;
    plot_time_series = false;
    
elseif nargin == 3
    plot_time_series = false;
    
end



switch model
    case 'ajtraps'
        fun = @aj_simple_model;
        
    case 'simple_traps'
        fun = @trap_model;
end

alphas = linspace(1e-4,1e4,nvars);
betas =  linspace(1e-4,1e4,nvars);
results = zeros(nvars, nvars);

%% simulate
for i = 1:nvars
    for j = 1:nvars
        alpha = alphas(i);
        beta = betas(j);


        ks = phase_constants(alpha, beta, @aj_constants_fun, I);
        dydt = aj_simple_model(I, ks);
        tspan = [0,1];

        y0 = [0;0;0];

        [ts, ys] = ode15s(dydt, tspan, y0);
        results(i,j) = ys(3,end);

        %% Plot results
        if plot_time_series
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
    end
end
% plot legend
if plot_time_series
    subplot(3,1,1)
    names = string(ints);
    legend(names);
end
   
[XS, YS] = meshgrid(alphas, betas);
figure()
scatter(XS(:), YS(:), NaN, results(:))
