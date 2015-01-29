%% This is a script to run all of the experiments
% To change the specifications of the parameters go to the 
% "Set Parameters" folder

% First you should add the entire folder to the directory like this:
% addpath(genpath('~/YourPathHere/PSRL_MATLAB/'))

% Caution - running these all at once may take a very long time.
% Large increases in speed can be made through the parallel computing
% toolbox. I have removed this dependency, but if you go into either RunInf
% or RunTau (in the experiments folder) you can change it here.

%--------------------------------------------------------------------

% 1 - Random Episodic MDPs with reset every tau
% (Both algorithms use episodic RL with optimality computed to tau)
clear
tauRandMDP

% 2 - Random Episodic MDPs without episodic reset 
% (Both algorithms use exponential episodes as per UCRL2)
clear
infRandMDP

% 3 - RiverSwim MDP with reset every tau steps
% (Both algorithms use episodic RL with optimality computed to tau)
clear
tauRiverSwim

% 4 - RiverSwim MDP without episodic reset
% (Both algorithms use exponential episodes as per UCRL2)
clear
infRiverSwim
