% States 1 to 6, 1 is left side with small reward, 6 is right big reward
S = 6;
% Action 1 moves left surely and action 2 attempts to go right.
A = 2;

pTrue = zeros(S,S,A);
rTrue = zeros(S,A);

% Set up the rewards
rTrue(1,1) = 0.005;
rTrue(S,2) = 1;

% Set up the transition probabilities
pTrue(:,:,1) = diag(ones((S-1),1),+1);
pTrue(1,1,1) = 1;

pTrue(:,1,2) = [0.4 0.6 zeros(1,S-2)]';
pTrue(:,S,2) = [zeros(1,S-2) 0.4 0.6]';

for i = 2:(S-1),
    pTrue(i-1,i,2) = 0.05;
    pTrue(i,i,2) = 0.6;
    pTrue(i+1,i,2) = 0.35;
end