%% MEMORY MANAGEMENT

% Maintain array for membranePotential to enable the solving of the
% differential equation for the LIF neurons
 membranePotentials = zeros(size(Iapplied,1),3); 
 membranePotentials(:,3) = EL;
 membranePotentials(:,2) = EL;
 
% Make the following (cell) arrays:
 spikes = zeros(neuronCount,1);  % monitors when the neuron spikes
 %inSpikes = cell(neuronCount,1);  % monitors when the neuron recieves spikes
 %inSpikeWeights = cell(neuronCount,1);  % monitors the weights associated with the incoming spikes
 %inSpikeSource = cell(neuronCount,1); %monitors where the neurons is recieving its inputs from
 
% Variable for storing average excitatory synaptic weight values
 averageExcitatorySynapticWeight = zeros(1,size(time,2));
 
 
%% SIMULATION

for timestep = 1:size(time,2);
    % Average excitatory synaptic weight value
     averageExcitatorySynapticWeight(1,timestep) = sum(sum(Weights(1:(4/5)*neuronCount,:)),2)/((4/5)*neuronCount*(neuronCount/10));
    
    % At every timestep, calculate the incoming post-synaptic currents due to spikes:
     for neuronID = 1:neuronCount
        Iapplied(neuronID, timestep) = Iapplied(neuronID, timestep) + temporalSummation(inSpikes{neuronID}, timestep, inSpikeWeights{neuronID}, Io, taum, taus, dt);
     end

    % Calculate resulting membranePotentials for current timestep
    if(timestep==1) 
        [membranePotentials(:,:), spikes(:,timestep)] = LIF_Refractory(zeros(neuronCount,1), Iapplied(:,timestep), membranePotentials(:,:), timestep, dt, VT, EL); 
    else
        [membranePotentials(:,:), spikes(:,timestep)] = LIF_Refractory(Iapplied(:,timestep-1), Iapplied(:,timestep), membranePotentials(:,:), timestep, dt, VT, EL); 
    end    

    % Update spikeInfo for next timesteps
     for neuronID = 1:neuronCount
        if(spikes(neuronID, timestep)==1)
           for j = 1:size(Fanout{neuronID},2)       
                inSpikes{Fanout{neuronID}(j)} = [inSpikes{Fanout{neuronID}(j)}, timestep*dt + Delay{neuronID}(j)];
                inSpikeWeights{Fanout{neuronID}(j)} = [inSpikeWeights{Fanout{neuronID}(j)}, Weights(neuronID,Fanout{neuronID}(j))];
                inSpikeSources{Fanout{neuronID}(j)} = [inSpikeSources{Fanout{neuronID}(j)}, neuronID];
           end
        end
     end
     
     %Prepare spikes variable for next timestep
     if(timestep~=size(time,2)) spikes = [spikes, zeros(neuronCount,1)]; end
      
    %Implement STDP weight-change rules
    for neuronID = 1:((4/5)*neuronCount) %only excitatory synapses!
        if(spikes(neuronID, timestep)==1)
            %upStream Neurons
            upStreamCheck = zeros(1,neuronCount);
            for j = size(inSpikes{neuronID},2):1;
                if(inSpikes{neuronID}(j)<timestep*dt)
                    if((inSpikeSources{neuronID}(j)<=((4/5)*neuronCount))&&(upStreamCheck(inSpikeSources{neuronID}(j))~=1)) %only excitatory synapses!
                        Weights(inSpikeSources{neuronID}(j),neuronID) = Weights(inSpikeSources{neuronID}(j),neuronID)*(1 + Aup*exp(-(timestep*dt-inSpikes{neuronID}(j))/tauL));
                        upstreamCheck(inSpikeSources{neuronID}(j))=1;
                    end
                end
            end
            %downStream Neurons
            for j = 1:size(Fanout{neuronID},2)
                downStreamNeuronID = Fanout{neuronID}(j);
                Weights(neuronID,downStreamNeuronID) = Weights(neuronID,downStreamNeuronID)*(1 + Adown*exp(-(timestep*dt+Delay{neuronID}(j)-inSpikes{downStreamNeuronID}(1,size(inSpikes{downStreamNeuronID},2)))/tauL));
            end
        end
    end
    
end


