function weights_final = excitatoryResponseTraining(weights, taum, taus, gamma, Iapplied, mP, dt, spikeTimes, Io)
    deltaT = zeros(size(Iapplied,1),1);
    deltaW = zeros(size(Iapplied,1),1);
    weights_final = weights;

    spikeFlag = 0;
    while(spikeFlag==0)
        weights_final = weightUpdateExcitatory(weights_final, taum, taus, gamma, mP, dt, spikeTimes);

        Iapplied = temporalSummation(spikeTimes, Io, weights_final, taum, taus, dt);
        Iapp=sum(Iapplied,1);
        mP_postTraining = AEF('RS', Iapp, dt);

        if(max(mP_postTraining)==0)
            spikeFlag = 1;
        end
    end
end
