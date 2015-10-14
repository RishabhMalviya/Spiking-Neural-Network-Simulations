%% Simulation Methodology Explanation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The simulation assumes that the number of spikes being generated at every
%time step is a poisson distribution with the mean number of spikes
%generated per time step given by:
%
%lambda = (rate of spiking)*(length of time interval)
%
%The probability of more than 1 spike being generated in a small enough
%time interval will be negligible (because the value of 'lambda' will be
%small enough).
%
%A random number is generated from this Poisson distribution at every time 
%step. If the generated number is greater than zero, a spike is issued in
%the time step.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [spikeTrain, spikeTimes] = Stimulus(Ns, lambda, dt, T)

%% Set Pre-Defined Parameters of Simulation (User Input)
rate = lambda; %spikes/ms
timeStep = dt; %ms
spikeTrainLength = T; %ms


%% Generate Relevant Variables and Perform Simulation
t = (timeStep:timeStep:spikeTrainLength); %vector for time steps
lambda = timeStep*rate; %Poisson parameter to calculate probabilities
pd = makedist('Poisson', 'lambda', lambda); %Poisson distribution for sampling random number
spikeTrain = zeros(Ns,length(t)); %output variable
for j = 1:Ns
    for i = 1:length(t)
        simStep(j,i) = random(pd, 1);
        if(simStep(j,i)<1) 
            spikeTrain(j,i)=0;
        else
            spikeTrain(j,i)=1;
        end
    end
end

%% Modify spikeTrain to store time steps at which spikes occur
spikeTimes = zeros(size(spikeTrain));
for j = 1:Ns
    for i = 1:length(t)
        if(spikeTrain(j,i)==1)
            spikeTimes(j,i) = (i*timeStep);
        end
    end
end

end