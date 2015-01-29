function [pHat, pDist, rHat, rDist] = ...
    computeConfidence( vTot, pEmp, rEmp, t, delta)
%computeConfidence creates the confidence sets for UCRL2 based
%on the empirical data thus far.
%------------------------------------------------------------------
% vTot   - SxA total number of visits to each (s,a) pair
% pEmp   - SxSxA total empirically observed transitions
% rEmp   - SxA total empirically observed rewards
% t      - 1x1 time of algorithm
% delta  - 1x1 confidence parameter
%------------------------------------------------------------------
% pHat   - SxSxA estimate of transition probabilities
% pDist  - SxA L1 bounds on probability distance
% rHat   - SxA estimate of reward function
% rDist  - SxA real bound on reward distance
%------------------------------------------------------------------

[S,A] = size(rEmp);
rHat = zeros(S,A);
rDist = zeros(S,A);
pHat = zeros(S,S,A);
pDist = zeros(S,A);


for action = 1:A,
    for state = 1:S,
        nObs = sum(pEmp(:,state,action));
        
        if(nObs > 0)
            rHat(state,action) = rEmp(state,action) / nObs;
            pHat(:,state,action) = pEmp(:,state,action) / nObs;
        
            rDist(state,action) = sqrt(7*log(2*S*A*t/delta) / (2*nObs));
            pDist(state,action) = sqrt(14*log(2*S*A*t/delta) / nObs);
        else
            rDist(state,action) = sqrt(7*log(2*S*A*t/delta) /2);
            pDist(state,action) = sqrt(14*log(2*S*A*t/delta) );
            
        end
        
    end
end


end


