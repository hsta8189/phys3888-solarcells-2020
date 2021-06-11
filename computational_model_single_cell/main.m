close all;
clearvars;

%% setup rate constants
e = 1.602e-19; % fundamental charge in coulombs
% for other constants see  aj_constants_fun()

%% set up simulation
nints = 100; % number of intensity calculations
plotTimeSeries = false;
plotParallel = false; % whether to plot experimental data on the simulation data plot



% intensities to use, both linear and logarithmic are used to catch the
% different trends and plot nicely
ints = [linspace(1,1000, nints), logspace(0,log10(1000), nints)];

% initialise array
nes = zeros(nints,1);
nts = zeros(nints,1);
nxs = zeros(nints,1);
nhs = zeros(nints,1);

i = 1;
for I=ints
    
        
    incidentWavelength = 500e-9; %m
    % absorbance = 1.5e6; %photons absorbed per metre of film thickness, #photons / m
    absorbance = 10e6; %photons absorbed per metre of film thickness, #photons / m
    filmThickness = 500e-9; %m

    % literature verified  constants
    [ks, epsilon, mu_h, mu_e, d] = aj_constants_fun(I, incidentWavelength, absorbance, filmThickness);

    
    % Current model:
    dydt = curr_model(I, ks, epsilon, mu_h, mu_e, d);

    % time interval (in seconds) to integrate over
    % physcially meaningless as long as enough time passes to reach
    % equilibrium
    tspan = [0,40];

    % inital conditions [conc exitons, conc occupied traps, conc of free electrons] 
    y0 = [0;0;0];

    % integrate using stiff ode solver
    [ts, ys] = ode15s(dydt, tspan, y0);
    
    % split results at equilibrium into some nicer to read arrays
    nes(i) = ys(end,3);
    nts(i) = ys(end,2);
    nxs(i) = ys(end,1);
    i = i + 1;
    if plotTimeSeries
        % time series is mostly useless from a scientific sense under this
        % model as does not physically represent time evolution
        % Useful for debugging and understanding the effects of rate
        % constants on the equilibrium
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
end

if plotTimeSeries
    subplot(2,2,1)
    names = string(ints);
    l = legend(names);
    title(l, 'Intensity (watts)')
end

% calculate holes and current density
nhs = nes + nts;
% short circuit curret density, see report
Jsc = e^2 * d * (mu_h* nhs + mu_e * nes).* (nhs - nes)/ epsilon;

h = 6.626e-34; %Planck's constant, m^2 kg / s
c = physconst("Lightspeed"); 

incidentWavelength = 500e-9; %m

photonEnergy = (h * c) ./ incidentWavelength; %energy of the given incident photons, J
photonFluxDensity = I ./ photonEnergy; %photon flux density, #photons.m^-2.s^-1

quantum_efficiency = (Jsc / e) / photonFluxDensity;
%% Plot results
figure()
subplot(2,3,1)
hold on;
scatter(ints(nints + 1:end), nxs(nints + 1:end), 1, 'k')
% plot(ints, nxs)
set(gca,'xscale','log')
set(gca,'yscale','log')


ylabel("Exciton concentration (m^{-3})")
xlabel("Incident intensity, \lambda = 500nm, (W/m^2)")

subplot(2,3,2)
hold on;
scatter(ints(nints + 1:end), nts(nints+ 1:end), 1, 'k')
% plot(ints, nts)
% line([0;1000], [ks(7); ks(7)])


set(gca,'xscale','log')
set(gca,'yscale','log')


ylabel("Occupied trap concentration (m^{-3})")
xlabel("Incident intensity, \lambda = 500nm, n_T = 2.5e22, (W/m^2)")

subplot(2,3,3)
hold on;
scatter(ints(nints+ 1:end), nes(nints+ 1:end), 1, 'k')
% plot(ints, nes)
set(gca,'xscale','log')
set(gca,'yscale','log')


ylabel("Free electron concentration (m^{-3})")
xlabel("Incident intensity, \lambda = 500nm, (W/m^2)")


% Experimental J_sc, sourced from main/Light Intensity IV
subplot(2,3,4)
hold on;
filters = [1001 917 772 638 591 512 445 226 181 100 89 7]; %W/m^2
filter_labels = ['sun' 'T89' 'T75' 'T63' 'T56' 'T51' 'T39' 'T20' 'T18' 'T8' 'T5.1' 'Room'];
x = filters;

J_sc = [20.33108177 18.4752409 15.9533325 13.19578601 12.82105289 10.75038663 10.06602349 5.169450001 4.316684523 3.274100686 2.361920534 0.101659462];
scatter(x,J_sc, 6, 'k')

title('Experimental Data')
xlabel('Intensity (W/m^2)')
xlim([0 1002])
ylabel('Short Circuit Current (mA/cm^2)')

subplot(2,3,5)
hold on;
if plotParallel
    scatter(x,J_sc, 20, 'r')
    plot(ints(1:nints), Jsc(1:nints) * 10^(-1), 'k')
    legend(["Experimental Data", "Model Fit"])
else
    scatter(ints(1:nints), Jsc(1:nints) * 10^(-1), 1, 'k')
    % plot(ints, Jsc)
    %set(gca,'xscale','log')
    % set(gca,'yscale','log')

end

ylabel("Short Circuit Current  (mA/cm^2)")
xlabel("Intensity  (W/m^2)")

subplot(2,3,6)
scatter(ints(nints+ 1:end), quantum_efficiency(nints+ 1:end), 1, 'k')
xlabel("Incident intensity, \lambda = 500nm, (W/m^2)")
ylabel("quantum efficiency")

set(gca,'xscale','log')
set(gca,'yscale','log')

