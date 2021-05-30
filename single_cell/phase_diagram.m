function results = phase_diagram(model, I, alpha_lower_mult, alpha_upper_mult, beta_lower_mult, beta_upper_mult, nalphas, nbetas, plot_time_series, runtime)
%% set up simulation and rate constants

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

alphas = alpha0 * 10.^ linspace(log10(alpha_lower_mult), log10(alpha_upper_mult), nalphas) ;
betas =  beta0 * 10 .^ linspace(log10(beta_lower_mult), log10(beta_upper_mult), nbetas) ;
results = zeros(nalphas, nbetas);
currs = zeros(nalphas, nbetas);


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
        Jsc = e^2 * d * (mu_h* nh + mu_e * ne).* (nh - ne)/ epsilon;
        
        h = 6.626e-34; %Planck's constant, m^2 kg / s
        c = physconst("Lightspeed"); 

        incidentWavelength = 500e-9; %m

        photonEnergy = (h * c) ./ incidentWavelength; %energy of the given incident photons, J
        photonFluxDensity = I ./ photonEnergy; %photon flux density, #photons.m^-2.s^-1

        quantum_efficiency = (Jsc(end) / e) / photonFluxDensity;
        
        results(i,j) = quantum_efficiency;
        currs(i,j) = Jsc(end);

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
   
[XS, YS] = meshgrid(log10(alphas), log10(betas));
figure()
colormap(hsv)
results = currs;
p =pcolor(XS, YS, log10(abs(results')));
% set(p, 'EdgeColor', 'none');
xlabel('Trapping / detrapping order log10(kT / kdT)')
ylabel('Exiton dissociation / free charge recombination order  log10(k1 / kr)')
title(sprintf("Phase diagram at I=%dW/m^2,", I) )
c = colorbar();
c.Label.String = 'log10(Jsc)';
