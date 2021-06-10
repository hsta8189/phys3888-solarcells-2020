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

% whether to regenerate the matrix, this is quite time intensive as it involves solving nalphas * nbetas odes.
makenew = true;


if makenew
    currvals = phase_diagram('curr_model', intensity, alpha_lower_mult, alpha_upper_mult, beta_lower_mult, beta_upper_mult, nalphas, nbetas, plot_time_series, runtime);
    save('phase_data/results.mat', currvals);
else
    currvals = load('phase_data/results.mat', currvals);
    % plot phase diagram
    [XS, YS] = meshgrid(log10(alphas / alpha0), log10(betas / beta0));
    figure()
    hold on;
    colormap(hsv)

    p =pcolor(XS, YS, log10(abs(currvals')));
    set(p, 'EdgeColor', 'none');
    plot([0], [0], 'xk', 'MarkerSize', 30) % plot lit values


    xlabel('Multiple of literature trapping / detrapping rate (kT / kdT)')
    ylabel('Multiple of literature exciton dissociation / free charge recombination rate (k1 / kr)')
    %title(sprintf("Phase diagram at I=%dW/m^2, X is literature constants", I) )

    f = gca();
    xs = f.XTickLabel;
    ys = f.YTickLabel;


    % Make the scale labels multiples rather than log10(multiple)
    for i = 1:length(xs)
        xs{i} = sprintf("10^{%s}", xs{i});
    end

    for i = 1:length(ys)
        ys{i} = sprintf("10^{%s}", ys{i});
    end

    f.XTickLabel = xs;
    f.YTickLabel = ys;

    c = colorbar();
    c.Label.String = 'log10(Jsc)';

    % Adjust font size for readability
    f.FontSize = 16;
    c.FontSize = 18;
end