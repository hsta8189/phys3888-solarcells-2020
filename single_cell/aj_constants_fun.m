function [ks, epsilon, mu_p, mu_e, filmThiccness] = aj_constants_fun(I, incidentWavelength, absorbance, filmThiccness)
%AJ_CONSTANTS_FUN Calculate a vector of constants (ks) for the
%aj_simple_model.

%% constant constants:
h = 6.626e-34; %Planck's constant, m^2 kg / s
c = physconst("Lightspeed"); 

if nargin<2
    incidentWavelength = 500e-9; %m
    absorbance = 1.5e6; %photons absorbed per metre of film thickness, #photons / m
    filmThiccness = 100e-9; %m
elseif nargin<3
    filmThiccness = 100e-9; %m
    incidentWavelength = 500e-9; %m
end

%% Generation rate calculations: 
% take an incident intensity in W/m^2 at a given wavelength, and output a 
% generation rate of electron/hole pairs. 
photonEnergy = (h * c) ./ incidentWavelength; %energy of the given incident photons, J
photonFluxDensity = I ./ photonEnergy; %photon flux density, #photons.m^-2.s^-1

G0 = photonFluxDensity .* absorbance; %photons.m^-3.s^-1

%% k1: how rapidly do excitons dissociate
%assume a temperature-activated Arrhenius eqn for a binding energy
k1 = 10^12; %s^-1 (STRANK)

%% kd1: decay rate one. How quickly do excitons decay (non-radiatively)
kd1 = 1e7; %%s^-1 (STRANK) (or 1 - 250 e6, HERZ)

%% kr: bimolecular recombination rate: 10^-3 to 10^-5
kr = 10e-3; %m^-3.s^-1 (HERZ)(SAJID)

%% Trapping, detrapping rates and trap concentration (STRANKS 2014)
kt = 2e-4; %m^3.s^-1
kdt = 8e-6; %m^3.s^-1
T = 2.5e22; %m^-3 (STRANK) (or 10e22 - 10e23, HERZ)

%% list of constants
ks = zeros(1, 7);
ks(1) = k1; %exciton dissociation rate
ks(2) = kd1; %non-radiative exciton decay
ks(3) = kr; %recombination rate

ks(4) = kt; %trapping rate
ks(5) = kdt; %detrapping rate
ks(6) = T; %concentration of traps in material

ks(7) = G0; %generation rate

%% constants for current calculation
% mobilities assumed constant

mu_e = 1e-8; %% PLACEHOLDER
mu_p = 1e-8; %% PLACEHOLDER

epsilon0 = 8.85e-12; %C^2 /Nm^2
epsilonrel = 15; %% PLACEHOLDER

epsilon = epsilon0 * epsilonrel;
end

