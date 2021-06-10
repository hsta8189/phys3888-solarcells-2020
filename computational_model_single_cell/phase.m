%close all;
%clearvars;

intensity = 1000;
% the phase diagram is generatred by taking the literature accepted values
% and scaling them by the below constants, then determining the equilibrium
% constants
alpha_lower_mult = 1e-2; % lowest multiple of alpha to use
alpha_upper_mult = 1e5; % highest multiple of alpha to use
beta_lower_mult = 1e-4; % lowest multiple of beta to use
beta_upper_mult = 1e2; % highest multiple of beta to use

% number of test values to compute in the phase space
nalphas = 100;
nbetas = 100;


plot_time_series = false; % whether to plot time evolution
runtime = 40; %time to run model for in seconds

currvals = phase_diagram('curr_model', intensity, alpha_lower_mult, alpha_upper_mult, beta_lower_mult, beta_upper_mult, nalphas, nbetas, plot_time_series, runtime);