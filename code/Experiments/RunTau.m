%% Run the finite horizon experiment

% Set up the holders for regret variables
rUCRL2 = zeros(T,nIters);
rPSRL = zeros(T,nIters);
trueVal = zeros(nIters,S);
rhoList = zeros(1,nIters);

% This loop should be a parfor, but you need the parallel toolbox.

for (i=1:nIters),
    %disp('Simulating random MDP: ')
    %disp(i)
    % Creating the true random MDP
    pTrue = sampleDirichletMat(alpha0);
    [rTrue, varSample] = sampleNormalGammaMat(mu0, nMu0, tau0,nTau0,0,0,0);
    s1 = 1;
    
    % Work out optimal values
    [value policy] = dpValueIteration(pTrue,rTrue,tau);
    trueVal(i,:) = value';
    
    % Running UCRL2Finite and PSRL on the MDP
    [rUCRL2(:,i) states actions values pols] = ...
    UCRL2Finite(M, tau, pTrue, rTrue, s1, delta);

    [rPSRL(:,i) states actions values pols vTot] = ...
    PSRL(M, tau, pTrue, rTrue, s1, mu0, nMu0, tau0, nTau0, alpha0);
    
end

rhoList = trueVal(:,s1)'*M;