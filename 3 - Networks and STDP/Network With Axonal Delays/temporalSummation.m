%% I_postSynaptic = temporalSummation(inSpikes, timestep, inSpikeWeights, Io, we, taum, taus, dt)

function I_postSynaptic = temporalSummation(inSpikes, timestep, inSpikeWeights, Io, taum, taus, dt)

    %Prepare output variables
    I_postSynaptic = 0;
    
    % Perform temporal summation
    for i = 1:size(inSpikes,2)
        if((inSpikes(1,i))<=(timestep*dt))
            I_postSynaptic = I_postSynaptic + Io*inSpikeWeights(i)*(exp(-((timestep*dt)-inSpikes(i))/taum) - exp(-((timestep*dt)-inSpikes(i))/taus));
        end
    end
    
end