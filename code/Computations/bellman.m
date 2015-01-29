function [ newVal, newPol ] = bellman( oldVal, probs, rewards)
%bellman operates with a bellman operator for the specific P and rewards
%which are given as above. This is pretty standard.
%------------------------------------------------------------------
% oldVal - Sx1 old estimate of the value function
% probs  - SxSxA estimate of transition probabilities
% rewards- SxA estimate of reward function
%------------------------------------------------------------------
% newVal - Sx1 new value function
% newPol - Sx1 new policy to take
%------------------------------------------------------------------

[S A] = size(rewards);
superSmall = 1.e-8;
qVals = ones(S,A);

for state = 1:S,
    for action = 1:A,
    % Loop through each (s,a) pair and create qVals for each
        qVals(state,action) = rewards(state,action) + ...
            dot(probs(:,state,action),oldVal);
    end
end

% Now we need to work out the best actions for each state
qVals = qVals+superSmall*randn(S,A);
newVal = max(qVals,[],2);

[newVal newPol] = max(qVals,[],2);
end