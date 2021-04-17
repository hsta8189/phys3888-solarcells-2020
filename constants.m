%%
%Generation rate calculations: take an incident intensity in W/m^2 at a
%given wavelength, and output a generation rate of electron/hole pairs. 

%global constants:
h = 6.626e-34; %Planck's constant, m^2 kg / s
c = physconst("Lightspeed"); %speed of light, m/s

%user inputted:
incidentIntensity = 1000; %W/m^2
incidentWavelength = 500e-9; %m
absorbance = 1.5e6; %photons absorbed per metre of film thickness, #photons / m
filmThickness = 100e-9; %m

%calculations:
photonEnergy = (h * c) ./ incidentWavelength; %energy of the given incident photons, J
photonFluxDensity = incidentIntensity ./ photonEnergy; %photon flux density, #photons.m^-2.s^-1

GenerationRate = photonFluxDensity .* absorbance; %photons.m^-3.s^-1

%% kr2: bimolecular recombination rate: 10^-3 to 10^-5
kr2 = 10e-3 %m^-3.s^-1

%% k1: how rapidly do excitons dissociate
%assume a temperature-activated Arrhenius eqn for a binding energy
k1 = exp

%% kd1: decay rate one. How quickly do excitons decay (non-radiatively)
kd1 = 1e-6 .* 1e6 %%cm^3/s, up to 250e-6












