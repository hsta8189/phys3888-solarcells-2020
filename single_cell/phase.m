close all;
clearvars;

intensity = 100;

alpha_lower_mult = .1; % lowest multiple of alpha to use
alpha_upper_mult = 10; % highest multiple of alpha to use
beta_lower_mult = 1e-2; % lowest multiple of beta to use
beta_upper_mult = 1e2; % highest multiple of beta to use

nalphas = 10;
nbetas = 40;

plot_time_series = false;
runtime = 40e-6; %time to run model for in seconds

currvals = phase_diagram('curr_model', intensity, alpha_lower_mult, alpha_upper_mult, beta_lower_mult, beta_upper_mult, nalphas, nbetas, plot_time_series, runtime);