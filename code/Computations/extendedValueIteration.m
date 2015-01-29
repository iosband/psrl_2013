function [value policy flag] = ...
    extendedValueIteration( pHat, pDist, rHat, rDist, epsilon, maxIter)
%extendedValueIteration implements the crucial step for UCRL2
%to compute the optimal policy over an optimistic confidence set.
%For fixed rewards we can let rDist=0s, but pDist is needed 
%------------------------------------------------------------------
% pHat   - SxSxA estimate of transition probabilities
% pDist  - SxA L1 bounds on probability distance
% rHat   - SxA estimate of reward function
% rDist  - SxA real bound on reward distance
% epsilon- 1x1 tolerance for convergence
% maxIter- 1x1 maximum number of iterations
%------------------------------------------------------------------
% value  - Sx1 new value function
% policy - Sx1 new policy to take
% flag   - 1x1 0 signals epsilon convergence, 1 for maxIter
%------------------------------------------------------------------

[S A] = size(pDist);
oldVal = zeros(S,1);
complete = false;
err = 1;
nIter =1;
flag =1;

while( ~complete),
    % Keep applying the extended bellman operator until convergence
    [value, policy] = extendedBellman(oldVal, pHat, pDist, rHat, rDist);
    
    err = span(value-oldVal);
    nIter=nIter+1;
    oldVal = value;
    
    if(err<epsilon),
        complete=true;
        flag=0;
    end
    
    if(nIter>maxIter),
        complete=true;
    end
end

end

