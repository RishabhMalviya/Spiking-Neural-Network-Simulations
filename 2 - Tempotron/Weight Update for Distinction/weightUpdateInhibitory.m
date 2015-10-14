function weights_final = weightUpdateInhibitory(weights, taum, taus, gamma, membranePotential, dt, spikeTimes)

    spikePositions = (membranePotential==0);
    
    deltaT = zeros(size(spikeTimes,1),1);
    deltaW = zeros(size(spikeTimes,1),1);
    weights_final = weights;
    
    for k = 1:size(spikeTimes,2)
        if(spikePositions(k))
            T = k*dt;
            for i = 1:size(spikeTimes,1)
                j = k;
                while((j~=1)&&(spikeTimes(i,j)==0)) 
                    j = j - 1;
                end
                if(spikeTimes(i,j)~=0)
                    deltaT(i) = T-spikeTimes(i,j);
                else
                    deltaT(i) = 0;
                end
                deltaW(i) = deltaW(i) + weights(i)*gamma*(exp(-deltaT(i)/taum) - exp(-deltaT(i)/taus));
            end
        end
    end
    
    weights_final = weights_final + deltaW;
    for i = 1:100
        if(weights_final(i,1)<10)
            weights_final(i,1)=10;
        end
    end
    
end