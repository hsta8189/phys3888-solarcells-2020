%% Generation rate calculations: 
% take an incident intensity in W/m^2 at a given wavelength, and output a 
% generation rate of electron/hole pairs. 

%% constant constants:
h = 6.626e-34; %Planck's constant, m^2 kg / s
c = physconst("Lightspeed"); 

%% user inputted:
I = 1000; %W/m^2, incident intensity
incidentWavelength = 500e-9; %m
absorbance = 1.5e6; %photons absorbed per metre of film thickness, #photons / m
filmThickness = 100e-9; %m

%calculations:
photonEnergy = (h * c) ./ incidentWavelength; %energy of the given incident photons, J
photonFluxDensity = incidentIntensity ./ photonEnergy; %photon flux density, #photons.m^-2.s^-1

G0 = photonFluxDensity .* absorbance; %photons.m^-3.s^-1

%% k1: how rapidly do excitons dissociate
%assume a temperature-activated Arrhenius eqn for a binding energy
k1 = 10^12 %s^-1 (STRANK)

%% kd1: decay rate one. How quickly do excitons decay (non-radiatively)
kd1 = 1e7 %%s^-1 (STRANK) (or 1 - 250 e6, HERZ)

%% kr: bimolecular recombination rate: 10^-3 to 10^-5
kr = 10e-3 %m^-3.s^-1 (HERZ)(SAJID)

%% Trapping, detrapping rates and trap concentration (STRANKS 2014)
kt = 2e-4 %m^3.s^-1
kdt = 8e-6 %m^3.s^-1
T = 2.5e22 %m^-3 (STRANK) (or 10e22 - 10e23, HERZ)

%% list of constants
k1 = ks(1); %exciton dissociation rate
kd1 = ks(2); %non-radiative exciton decay
kr = ks(3); %recombination rate

kt = ks(4); %trapping rate
kdt = ks(5); %detrapping rate
T = ks(6); %concentration of traps in material

G0 = ks(7); %generation rate


