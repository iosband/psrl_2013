%% Random MDPs with tau horizon comparison
% We are going to sample random MDPs from a certain prior.

disp('Running the experiments on Random MDPs from the prior with episodic reset')
disp('We compare performance of UCRL2Finite to PSRL')

SetRandMDP
SetPriors
SetExperiment
RunTau
PlotGraphs