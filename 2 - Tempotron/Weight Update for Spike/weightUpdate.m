function [weights_final, deltaT, deltaW] = weightUpdate(weights, taum, taus, gamma, Iapplied, membranePotential, dt, spikeTimes)

    [maxValue,maxPosition] = max(membranePotential);
    
    deltaT = zeros(size(Iapplied,1),1);
    deltaW = zeros(size(Iapplied,1),1);
    T = maxPosition*dt;
    
    for i = 1:size(Iapplied,1)
        j = maxPosition;
        while((j~=1)&&(spikeTimes(i,j)==0)) 
            j = j - 1;
        end
        if(spikeTimes(i,j)~=0)
            deltaT(i) = T-spikeTimes(i,j);
        else
            deltaT(i) = 0;
        end
        deltaW(i) = weights(i)*gamma*(exp(-deltaT(i)/taum) - exp(-deltaT(i)/taus));
    end
    
    weights_final = weights + deltaW;
    
end