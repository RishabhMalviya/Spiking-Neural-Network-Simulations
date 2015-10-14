load('wo.mat');
load('problemFive.mat')

%% Part (a) - Responses to S1 and S2 with Initial Weights
load('spikes1.mat');
Iapplied = temporalSummation(spikeTimes, Io, weights, taum, taus, dt);
Iapp=sum(Iapplied,1);
mP = AEF('RS', Iapp, dt);
plot(t,mP);

load('spikes2.mat');
Iapplied = temporalSummation(spikeTimes, Io, weights, taum, taus, dt);
Iapp=sum(Iapplied,1);
mP = AEF('RS', Iapp, dt);
plot(t,mP);


%% Training to reduce response to S2
deltaT = zeros(size(Iapplied,1),1);
deltaW = zeros(size(Iapplied,1),1);
weights_final = weights;

spikeFlag = 1;
numIterations = 0;
while(spikeFlag==1)
    [weights_final, deltaT(:,numIterations+1), deltaW(:,numIterations+1)] = weightUpdateInhibitory(weights_final, taum, taus, gamma, mP, dt, spikeTimes);
    
    %[spikeTrain, spikeTimes] = Stimulus(Ns, lambda, dt, T);
    Iapplied = temporalSummation(spikeTimes, Io, weights_final, taum, taus, dt);
    Iapp=sum(Iapplied,1);
    mP_postTraining = AEF('RS', Iapp, dt);
    hold on;
    plot(t,mP_postTraining);
    
    numIterations = numIterations + 1;
    
    if(max(mP_postTraining)~=0)
        spikeFlag = 0;
    else
        deltaT = [deltaT, zeros(size(Iapplied,1),1)];
        deltaW = [deltaW, zeros(size(Iapplied,1),1)];
    end
end

save w1.mat weights_final;

hold off;
plot(t,mP_postTraining,'red');


%% Training above obtained weights to get S1 to spike
load('spikes1.mat');
gamma = 1;

deltaT = zeros(size(Iapplied,1),1);
deltaW = zeros(size(Iapplied,1),1);

spikeFlag = 0;
numIterations = 0;
while(spikeFlag==0)
    [weights_final, deltaT(:,numIterations+1), deltaW(:,numIterations+1)] = weightUpdate(weights_final, taum, taus, gamma, Iapplied, mP, dt, spikeTimes);
    
    %[spikeTrain, spikeTimes] = Stimulus(Ns, lambda, dt, T);
    Iapplied = temporalSummation(spikeTimes, Io, weights_final, taum, taus, dt);
    Iapp=sum(Iapplied,1);
    mP_postTraining = AEF('RS', Iapp, dt);
    hold on
    plot(t,mP_postTraining,'cyan');
    
    numIterations = numIterations + 1;
    
    if(max(mP_postTraining)==0)
        spikeFlag = 1;
    else
        deltaT = [deltaT, zeros(size(Iapplied,1),1)];
        deltaW = [deltaW, zeros(size(Iapplied,1),1)];
    end
end


%% Discriminating between S1 and S2 with S1 inhibited
clear;
clc;

discriminatoryWeights_IE;



