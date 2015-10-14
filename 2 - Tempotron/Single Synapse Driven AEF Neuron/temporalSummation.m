%% Iapplied = temporalSummation(spikeTrain, Io, we, taum, taus, dt)
% Iapplied is the output of size 1x(number of timesteps)
% spikeTrain contains the times at which spikes arrive at the pre-synaptic 
% neuron, of the same size as Iapplied.
% Io is the current constant
% we is the synaptic strength
% taum is the membrane time constant
% taus is the synaptc time constant


function Iapplied = temporalSummation(spikeTimes, Io, we, taum, taus, dt)

    %Prepare output variables
    Iapplied = zeros(size(spikeTimes));
    
    %Calculate post-synaptic current for each timestep
    for i = 1:size(Iapplied,2)
        for j = 1:i
            if(spikeTimes(1,j)~=0)
                Iapplied(1,i) = Iapplied(1,i) + Io*we*(exp(-(i*dt-spikeTimes(1,j))/taum) - exp(-(i*dt-spikeTimes(1,j))/taus));
            end
        end    
    end
    
end