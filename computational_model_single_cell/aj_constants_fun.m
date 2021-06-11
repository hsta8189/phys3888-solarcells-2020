function [ks, epsilon, mu_p, mu_e, filmThiccness] = aj_constants_fun(I, incidentWavelength, absorbance, filmThiccness)
%AJ_CONSTANTS_FUN Calculate a vector of constants (ks) for the
%aj_simple_model.

%% constant constants:
h = 6.626e-34; %Planck's constant, m^2 kg / s
c = physconst("Lightspeed"); 
kB = physconst('Boltzmann');
temp = 300;

if nargin<2
    incidentWavelength = 500e-9; %m
    %  absorbance = 1.5e6; %photons absorbed per metre of film thickness, #photons / m
    absorbance = 10e6; %photons absorbed per metre of film thickness, #photons / m
    filmThiccness = 500e-9; %m
elseif nargin<3
    filmThiccness = 500e-9; %m
    incidentWavelength = 500e-9; %m
end

%% Generation rate calculations: 
% take an incident intensity in W/m^2 at a given wavelength, and output a 
% generation rate of electron/hole pairs. 
photonEnergy = (h * c) ./ incidentWavelength; %energy of the given incident photons, J
photonFluxDensity = I ./ photonEnergy; %photon flux density, #photons.m^-2.s^-1

G0 = photonFluxDensity .* absorbance; %photons.m^-3.s^-1

%% k1: how rapidly do excitons dissociate
k1 = 10^12; %s^-1 (STRANK)

%% Exciton decay rates (non-radiatively k1 or radiatively kdr)
kd1 = 250e6; %%s^-1 (HERZ)
kdr = 1e9; % (HERZ)

%% kr: bimolecular recombination rate: 10^-3 to 10^-5
kr = 1e-5; %m^-3.s^-1 (HERZ)(SAJID)(JOHNSTON/HERZ 2016)

%% Trapping, detrapping rates and trap concentration
% (HO-BAILLIE)
kt = 1/(6.72e-8); %s^-1
kdt = 1/(1.68e-6); % s^-1

T = 2.5e22; %m^-3 (STRANK) (or 1e22 - 1e23, HERZ)

%% Future temp. dependency stuff: (not implemented)
% Ni = ;  % intrinsic carrier density
% beta = 1/(kB * temp); % thermodynamic temperatre (1/kT)
% delta = ; % E_{trap} - fermi energy

%% list of constants
ks = zeros(1, 7);
ks(1) = k1; %exciton dissociation rate
ks(2) = kd1; %non-radiative exciton decay
ks(3) = kdr;
ks(4) = kr; %recombination rate

ks(5) = kt; %trapping rate
ks(6) = kdt; %detrapping rate
ks(7) = T; %concentration of traps in material

ks(8) = G0; %generation rate

% ks(9) = Ni;  % intrinsic carrier density
% ks(10) = beta; % thermodynamic temperatre (1/kT)
% ks(11) = delta; % E_{trap} - fermi energy

%% constants for current calculation
% mobilities assumed constant

mu_e = 37e-4; %% (JOHNSTON/HERZ 2016)
mu_p = mu_e; %%

epsilon0 = 8.85e-12; %C^2 /Nm^2
epsilonrel = 15; 

epsilon = epsilon0 * epsilonrel;
end

