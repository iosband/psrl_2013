function [value policy] = ...
    dpValueIteration( probs, rewards, tau)
%dpValueIteration solves the dynamic programming problem over tau timesteps
%via value iteration.
%------------------------------------------------------------------
% probs  - SxSxA estimate of transition probabilities
% rewards- SxA estimate of reward function
% tau    - 1x1 timeframe for optimal policy
%------------------------------------------------------------------
% value  - Sx1 new value function
% policy - Sx1 new policy to take
%------------------------------------------------------------------

[S A] = size(rewards);
oldVal = zeros(S,1);
complete = false;
err = 1;
nIter =1;
flag =1;

for i=1:tau,
    % Apply the Bellman operator tau times
    [value, policy] = bellman(oldVal, probs, rewards);
    oldVal = value;
end

end
