% Here we set up the simulation parameters

T = 100000; % Total time for experiment
tau = 20; % Episode length (where appropriate)
M = T/tau; % Number of episodes (where appropriate)

nIters = 50;

rand('seed',0) % This is for reproducibility