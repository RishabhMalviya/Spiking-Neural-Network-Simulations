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
 
 
%% SIMULATION

for timestep = 1:size(time,2);
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
                inSpikeWeights{Fanout{neuronID}(j)} = [inSpikeWeights{Fanout{neuronID}(j)}, Weights{neuronID}(j)];
           end
        end
     end
     
     %Prepare spikes variable for next timestep
     if(timestep~=size(time,2)) spikes = [spikes, zeros(neuronCount,1)]; end
end


