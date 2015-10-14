load('problemThree.mat');
load('spikes.mat');


weights(1:100,1)=(wo+sigmaw*randn(100,1));
Iapplied = temporalSummation(spikeTimes, Io, weights, taum, taus, dt);
Iapp=sum(Iapplied,1);
mP = AEF('RS', Iapp, dt);
plot(t,mP);

deltaT = zeros(size(Iapplied,1),1);
deltaW = zeros(size(Iapplied,1),1);
weights_final = weights;

spikeFlag = 0;
numIterations = 0;
while(spikeFlag==0)
    [weights_final, deltaT(:,numIterations+1), deltaW(:,numIterations+1)] = weightUpdate(weights_final, taum, taus, gamma, Iapplied, mP, dt, spikeTimes);
    
    %[spikeTrain, spikeTimes] = Stimulus(Ns, lambda, dt, T);
    Iapplied = temporalSummation(spikeTimes, Io, weights_final, taum, taus, dt);
    Iapp=sum(Iapplied,1);
    mP_postTraining = AEF('RS', Iapp, dt);
    hold on
    plot(t,mP_postTraining);
    
    numIterations = numIterations + 1;
    
    if(max(mP_postTraining)==0)
        spikeFlag = 1;
    else
        deltaT = [deltaT, zeros(size(Iapplied,1),1)];
        deltaW = [deltaW, zeros(size(Iapplied,1),1)];
    end
end

createfigureWeights(1:100,[weights,weights_final]);

for i =1:4
scatter(deltaT(:,i),deltaW(:,i),5*ones(size(deltaT,1),1),'fill');
hold on
end
    