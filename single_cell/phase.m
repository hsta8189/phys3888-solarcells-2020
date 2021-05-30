%close all;
%clearvars;

intensity = 1000;

alpha_lower_mult = 1e0; % lowest multiple of alpha to use
alpha_upper_mult = 1e6; % highest multiple of alpha to use
beta_lower_mult = 1e0; % lowest multiple of beta to use
beta_upper_mult = 1e4; % highest multiple of beta to use

nalphas = 70;
nbetas = 40;

plot_time_series = false;
runtime = 40; %time to run model for in seconds

currvals = phase_diagram('curr_model', intensity, alpha_lower_mult, alpha_upper_mult, beta_lower_mult, beta_upper_mult, nalphas, nbetas, plot_time_series, runtime);