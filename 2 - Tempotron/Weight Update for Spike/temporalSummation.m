%% Iapplied = temporalSummation(spikeTrain, Io, we, taum, taus, dt)
% Iapplied is the output of size 1x(number of timesteps)
% spikeTrain contains the times at which spikes arrive at the pre-synaptic 
% neuron, of the same size as Iapplied.
% Io is the surrent constant
% we is the synaptic strength
% taum is the membrane time constant
% taus is the synaptc time constant


function Iapplied = temporalSummation(spikeTimes, Io, weights, taum, taus, dt)

    %Prepare output variables
    Iapplied = zeros(size(spikeTimes));
    
    %Calculate post-synaptic current for each timestep
    for k = 1:size(Iapplied,1)
        for i = 1:size(Iapplied,2)
            for j = 1:i
                if(spikeTimes(k,j)~=0)
                    Iapplied(k,i) = Iapplied(k,i) + Io*weights(k,1)*(exp(-(i*dt-spikeTimes(k,j))/taum) - exp(-(i*dt-spikeTimes(k,j))/taus));
                end
            end    
        end
    end

end