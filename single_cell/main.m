close all;
clearvars;

%% setup rate constants

e = 1.602e-19; % fundamental charge in coulombs
%% set up simulation
nints = 100;
plotTimeSeries = false;

ints = linspace(1,1200, nints);

nes = zeros(nints,1);
nts = zeros(nints,1);
nxs = zeros(nints,1);
nhs = zeros(nints,1);

i = 1;
for I=ints

    [ks, epsilon, mu_h, mu_e, d] = aj_constants_fun(I);
    dydt = curr_model(I, ks, epsilon, mu_h, mu_e, d);
    tspan = [0,40];

    y0 = [0;0;0];

    [ts, ys] = ode15s(dydt, tspan, y0);
    
    nes(i) = ys(end,3);
    nts(i) = ys(end,2);
    nxs(i) = ys(end,1);
    i = i + 1;
    if plotTimeSeries
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
scatter(ints, nxs, 1, 'k')
% plot(ints, nxs)
set(gca,'xscale','log')
set(gca,'yscale','log')


ylabel("Exciton Concentration")
xlabel("Incident intensity, \lambda = 500nm, (W/m^2)")

subplot(2,3,2)
hold on;
scatter(ints, nts, 1, 'k')
% plot(ints, nts)
set(gca,'xscale','log')
set(gca,'yscale','log')


ylabel("Occupied Trap Concentration")
xlabel("Incident intensity, \lambda = 500nm, N_t = 2.5e22, (W/m^2)")

subplot(2,3,3)
hold on;
scatter(ints, nes, 1, 'k')
% plot(ints, nes)
set(gca,'xscale','log')
set(gca,'yscale','log')


ylabel("Free Electron Concentration")
xlabel("Incident intensity, \lambda = 500nm, (W/m^2)")

subplot(2,3,4)
hold on;
scatter(ints, Jsc *10^3, 1, 'k')
% plot(ints, Jsc)
%set(gca,'xscale','log')
% set(gca,'yscale','log')


ylabel("Current density (mA/m^2)")
xlabel("Incident intensity, \lambda = 500nm, (W/m^2)")

subplot(2,3,5)
scatter(ints, quantum_efficiency, 1, 'k')
xlabel("Incident intensity, \lambda = 500nm, (W/m^2)")
ylabel("quantum efficiency")

set(gca,'xscale','log')
set(gca,'yscale','log')
