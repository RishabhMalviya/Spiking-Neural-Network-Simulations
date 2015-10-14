%% Preparing 'Fanout', 'Weights' and 'Delay' Cell Arrays
 Fanout = cell(neuronCount,1);
 Weights = cell(neuronCount,1);
 Delay = cell(neuronCount,1);
 
 for i = 1:(4/5)*neuronCount
     Fanout{i} = randperm(neuronCount,neuronCount/10);
     Weights{i} = we*ones(1,neuronCount/10);
     Delay{i} = rand(1,neuronCount/10)*20e-3;
 end
 
 for i = (((4/5)*neuronCount)+1):neuronCount
     Fanout{i} = randperm((4/5)*neuronCount,neuronCount/10);
     Weights{i} = (-wi)*ones(1,neuronCount/10);
     Delay{i} = ones(1,neuronCount/10)*1e-3;
 end
 

%% Preparing the Iapplied array
 Iapplied = zeros(neuronCount,size(time,2));


%% Preparing the 'inSpikes' and 'inSpikeWeights' cell array with the Poisson stimulus
 inSpikes = cell(neuronCount,1);
 inSpikeWeights = cell(neuronCount,1);
 %inStimulus = cell(neuronCount,1);
 
 for i = 1:25
     [inSpikes{i},] = Stimulus(lambda, dt, T);
     inSpikeWeights{i} = 3000*ones(1,size(inSpikes{i},2));
 end
     
     