% Here we have the specification of our prior and also the delta for UCRL2.

delta = 0.05;
mu0 = 1 * ones(S,A);
nMu0 = 1 * ones(S,A);
tau0 = 1 * ones(S,A);
nTau0 = 1 * ones(S,A);
alpha0 = 1/S * ones(S,S,A);
epsilon = 0.01;
maxIter = 1000;