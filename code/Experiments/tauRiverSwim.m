%% tau horizon RiverSwim transition model
%Canonical reinforcement learning problem, requires planning and
%exploration to perform well. See KL-UCRL Figure 1 for the example.

disp('Running the experiments for the RiverSwim MDP with episodic reset')
disp('We compare performance of UCRL2Finite to PSRL')

SetRiverSwim
SetPriors
SetExperiment
RunTau
PlotGraphs