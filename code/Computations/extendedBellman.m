function [newVal, newPol] = extendedBellman(oldVal, pHat, pDist, rHat, rDist)
%extendedBellman operates as an optimistic bellman operator
%the confidence set of MDPs as described in the JAO paper UCRL2.
%For fixed rewards we can let rDist=0s, but pDist is needed 
%------------------------------------------------------------------
% oldVal - Sx1 old estimate of the value function
% pHat   - SxSxA estimate of transition probabilities
% pDist  - SxA L1 bounds on probability distance
% rHat   - SxA estimate of reward function
% rDist  - SxA real bound on reward distance
%------------------------------------------------------------------
% newVal - Sx1 new value function
% newPol - Sx! new policy to take
%------------------------------------------------------------------

[S A] = size(pDist);
qVals = zeros(S,A);

rOpt = rHat + rDist;

for state = 1:S,
    for action = 1:A,
    % Loop through each (s,a) pair and create qVals for each
        pOpt = bestProbs(oldVal, pHat(:,state,action), pDist(state,action));
        qVals(state,action) = rOpt(state,action) + dot(pOpt,oldVal);
    end
end

    
% Now we need to work out the best actions for each state
[newVal newPol] = max(qVals,[],2);
end

