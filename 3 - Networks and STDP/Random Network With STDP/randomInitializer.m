%% Preparing 'Fanout', 'Weights' and 'Delay' Cell Arrays
 Fanout = cell(neuronCount,1);
 Weights_ = cell(neuronCount,1);
 Delay = cell(neuronCount,1);
 
 for i = 1:(4/5)*neuronCount
     Fanout{i} = randperm(neuronCount,neuronCount/10);
     Weights_{i} = we*ones(1,neuronCount/10);
     Delay{i} = rand(1,neuronCount/10)*20e-3;
 end
 
 for i = (((4/5)*neuronCount)+1):neuronCount
     Fanout{i} = randperm((4/5)*neuronCount,neuronCount/10);
     Weights_{i} = (-wi)*ones(1,neuronCount/10);
     Delay{i} = ones(1,neuronCount/10)*1e-3;
 end
 
 Weights = zeros(neuronCount);
 for i = 1:neuronCount
     for j = 1:size(Weights_{i},2)
         Weights(i,Fanout{i}(j)) = Weights_{i}(j);
     end
 end
 
 clear Weights_;

%% Preparing the Iapplied array
 Iapplied = zeros(neuronCount,size(time,2));


%% Preparing the 'inSpikes' and 'inSpikeWeights' 'inSpikeSources' cell array with the Poisson stimulus
 inSpikes = cell(neuronCount,1);
 inSpikeWeights = cell(neuronCount,1);
 inSpikeSources = cell(neuronCount,1);
 
 for i = 1:25
     [inSpikes{i},] = Stimulus(lambda, dt, T);
     inSpikeWeights{i} = 3000*ones(1,size(inSpikes{i},2));
     inSpikeSources{i} = zeros(1,size(inSpikes{i},2));
 end
     
     