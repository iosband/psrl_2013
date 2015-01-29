%% Here we will analyse the data, outputting the average regret and graphs
aveRewardPSRL = sum(rPSRL(:))/nIters;
aveRewardUCRL2 = sum(rUCRL2(:))/nIters;

meanRegPSRL = mean(rhoList)*T - aveRewardPSRL;
meanRegUCRL2 = mean(rhoList)*T - aveRewardUCRL2;

disp('Average Regret of PSRL: ')
meanRegPSRL
disp('Average Regret of UCRL2: ')
meanRegUCRL2


%-----------------------------------------------------------------------
% Now we are going to look at the cumulative regret over time.
regPSRL  = cumsum(repmat(rhoList,T,1)) - cumsum(rPSRL);
regUCRL2 = cumsum(repmat(rhoList,T,1)) - cumsum(rUCRL2);

worstPSRL = max(regPSRL,[],2);
avePSRL = mean(regPSRL,2);
bestPSRL = min(regPSRL,[],2);

worstUCRL2 = max(regUCRL2,[],2);
aveUCRL2 = mean(regUCRL2,2);
bestUCRL2 = min(regUCRL2,[],2);

%------------------------------------------------------------------------
% You need to show PSRL on a shorter time frame
tPSRL = 10000;

set(0,'defaultAxesFontName', 'arial');
set(0,'defaultTextFontName', 'arial');
set(gca,'FontSize',14) ;

%PSRL alone, min
figure
hold on
plot(avePSRL(1:tPSRL),'r','linewidth',1.5)
plot(bestPSRL(1:tPSRL),'r-.')
plot(worstPSRL(1:tPSRL),'r-.')
leg = legend('PSRL Regret (ave)','PSRL Regret (worst)', 'PSRL Regret (best)',...
    'Location','NorthWest');
set(leg,'FontSize',16)
xlabel('Time elapsed' , 'FontSize',20)
ylabel('Regret', 'FontSize',20)

%UCRL2 alone
axis([0 10000 -100 1000])
figure
hold on
plot(aveUCRL2,'b','linewidth',1.5)
plot(bestUCRL2,'b-.')
plot(worstUCRL2,'b-.')
legend('UCRL2 Regret (ave)','UCRL2 Regret (worst)', 'UCRL2 Regret (best)',...
    'Location','NorthWest')
xlabel('Time elapsed')
ylabel('Regret')

%UCRL2 and PSRL
figure
hold on
plot(avePSRL,'r','linewidth',1.5)
plot(bestPSRL,'r-.')
plot(worstPSRL,'r-.')
plot(aveUCRL2,'b','linewidth',1.5)
plot(bestUCRL2,'b-.')
plot(worstUCRL2,'b-.')
legend('PSRL Regret (ave)','PSRL Regret (worst)', 'PSRL Regret (best)', ...
    'UCRL2 Regret (ave)','UCRL2 Regret (worst)', 'UCRL2 Regret (best)', ...
    'Location','NorthWest')
xlabel('Time elapsed')
ylabel('Regret')

% Every single experiment together
figure
hold on
for i = 1:(nIters),
    plot(regPSRL(:,i),'r-.','linewidth',0.1)
    plot(regUCRL2(:,i),'b-.','linewidth',0.1)
end

leg = legend('PSRL Regret', 'UCRL2 Regret','Location','northwest');
set(leg,'FontSize',16)
xlabel('Time elapsed' , 'FontSize',20)
ylabel('Regret', 'FontSize',20)