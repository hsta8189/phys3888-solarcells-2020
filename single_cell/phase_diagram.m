function results = phase_diagram(model, I, alpha_lower_mult, alpha_upper_mult, beta_lower_mult, beta_upper_mult, nalphas, nbetas, plot_time_series, runtime)
%% set up simulation and rate constants
if nargin == 0
    model = 'curr_model';
    I = 1;
    alpha_lower_mult = 0.1;
    alpha_upper_mult = 10;
    beta_lower_mult = 0.1;
    beta_upper_mult = 10;
    nalphas = 10;
    nbetas = 10;
    plot_time_series = false;
    runtime = 40e-6;
    
elseif nargin == 1
    I = 1;
    alpha_lower_mult = 0.1;
    alpha_upper_mult = 10;
    beta_lower_mult = 0.1;
    beta_upper_mult = 10;
    nalphas = 10;
    nbetas = 10;
    plot_time_series = false;
    runtime = 40e-6;
    
elseif nargin == 2
    alpha_lower_mult = 0.1;
    alpha_upper_mult = 10;
    beta_lower_mult = 0.1;
    beta_upper_mult = 10;
    nalphas = 10;
    nbetas = 10;
    plot_time_series = false;
    runtime = 40e-6;
    
elseif nargin == 8
    plot_time_series = false;
    runtime = 40e-6;
    
end



switch model
    case 'ajtraps'
        fun = @aj_simple_model;
        
    case 'simple_traps'
        fun = @trap_model;
    case 'curr_model'
        fun = @curr_model;
end


%% constants
e = 1.602e-19; % fundamental charge in coulombs
[ks, epsilon, mu_h, mu_e, d] = aj_constants_fun(I);

alpha0 = ks(5) / ks(6);
beta0 = ks(1) / ks(4); 

alphas = linspace(alpha_lower_mult, alpha_upper_mult, nalphas) * alpha0;
betas =  linspace(beta_lower_mult, beta_upper_mult, nbetas) * beta0;
results = zeros(nalphas, nbetas);


if plot_time_series
    figure()
end
%% simulate
for i = 1:nalphas
    for j = 1:nbetas
        alpha = alphas(i);
        beta = betas(j);


        ks = phase_constants(alpha, beta, ks);
        dydt = fun(I, ks, epsilon, mu_h, mu_e, d);
        tspan = [0,runtime];

        y0 = [0;0;0];

        [ts, ys] = ode15s(dydt, tspan, y0);
        
        %% calculate results
        ne = ys(:,3);
        nt = ys(:,2);
        nx = ys(:,1);
        nh = ne + nt;
        Jsc = e^2 * d * (mu_h* nh - mu_e * ne).^2 / epsilon;
        
        results(i,j) = Jsc(end);

        %% Plot results
        if plot_time_series
            subplot(2,2,1)
            plot(ts(:) * 1e6, nx)
            hold on;

            ylabel("Exciton Concentration")
            xlabel("t (\mu s)")

            subplot(2,2,2)
            plot(ts(:) * 1e6, nt)
            hold on;

            ylabel("Occupied Trap Concentration")
            xlabel("t (\mu s)")

            subplot(2,2,3)
            plot(ts(:) * 1e6, ne)
            hold on;

            ylabel("Free Electron Concentration")
            xlabel("t (\mu s)")

            subplot(2,2,4)
            plot(ts(:) * 1e6, Jsc)
            hold on;

            ylabel("Current density")
            xlabel("t (\mu s)")
        end
    end
end
% plot legend
if plot_time_series
    subplot(3,1,1)
    names = string(ints);
    l = legend(names);
    title(l, 'Intensity (watts)')
end
   
[XS, YS] = meshgrid(alphas, betas);
figure()
pcolor(XS, YS, results');
xlabel('\alpha- value (kT / kdT)')
ylabel('\beta-value (k1 / kr)')
c = colorbar();
c.Label.String = 'J_{SC}';
