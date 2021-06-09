close all;
clearvars;

intensity = 100;

alpha_lower = 1e-1; % lowest multiple of alpha to use
alpha_upper = 1e0; % highest multiple of alpha to use
beta_lower = 1e-4; % lowest multiple of beta to use
beta_upper = 1e4; % highest multiple of beta to use

nalphas = 40;
nbetas = 40;

plot_time_series = false;
runtime = 40e-6; %time to run model for in seconds

currvals = phase_diagram_absolute('curr_model', intensity, alpha_lower, alpha_upper, beta_lower, beta_upper, nalphas, nbetas, plot_time_series, runtime);