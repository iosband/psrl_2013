function [action, s2, reward ] = singleStep(s1, policy, pTrue, rTrue)
%singleStep advances one timestep in the MDP according to the true
%parameters. We observe the new state and the reward associated.
%------------------------------------------------------------------
% pTrue  - SxSxA Probability transition matrices under actions
% rTrue  - SxA Working on a simple deterministic rewards
% s1     - 1x1 Initial state
% policy - Sx1 Says which action we take for a given state
%------------------------------------------------------------------
% action - 1x1 Action taken
% s2     - 1x1 The new state
% reward - 1x1 Observed reward
%------------------------------------------------------------------

[S A] = size(rTrue);

action = policy(s1);
reward = rTrue(s1,action);
s2 = discretesample(pTrue(:,s1,action),1);

end

