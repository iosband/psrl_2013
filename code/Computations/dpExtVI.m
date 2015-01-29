function [value policy] = ...
    dpExtVI( pHat, pDist, rHat, rDist, tau)
%dpExtVI implements the crucial step for UCRL2 but for a fixed tau episode
%to compute the optimal policy over an optimistic confidence set.
%For fixed rewards we can let rDist=0s, but pDist is needed 
%------------------------------------------------------------------
% pHat   - SxSxA estimate of transition probabilities
% pDist  - SxA L1 bounds on probability distance
% rHat   - SxA estimate of reward function
% rDist  - SxA real bound on reward distance
% tau    - 1x1 episode length
%------------------------------------------------------------------
% value  - Sx1 new value function
% policy - Sx1 new policy to take
%------------------------------------------------------------------

[S A] = size(pDist);
oldVal = zeros(S,1);
complete = false;
err = 1;
nIter =1;
flag =1;

for i=1:tau,
    % Apply the extended (optimistic) Bellman operator tau times
    [value, policy] = extendedBellman(oldVal, pHat, pDist, rHat, rDist);
    oldVal = value;
end

end

