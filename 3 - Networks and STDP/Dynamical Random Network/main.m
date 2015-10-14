%% SIMULATE
 load('postRandInit.mat');
 networkSolver;
 
 % OR, do this (it takes much longer):
 % load('preRandInit.mat');
 % randomInitializer;
 % networkSolver;
 
 
%% VISUALIZE
 x = cell(neuronCount,1);
 
 for i = 1:neuronCount
    for j = 1:length(time)
        if(spikes(i,j)==1) x{i} = [x{i},j]; end;
    end
 end
 
 for i = 1:neuronCount
    scatter(x{i},i*ones(size(x{i})),3,'blue','fill');
    hold on;
 end
 
 
%% CALCULATE Ri(t), Re(t)

 Ri = zeros(1,990);
 Re = zeros(1,990);
 
 for i = 1:990
    for j = 1:((4/5)*neuronCount)
        for k = 1:11
            if(spikes(j,i+k-1)==1) Re(1,i) = Re(1,i) + 1; end
        end
    end
    
    for j = (((4/5)*neuronCount)+1):neuronCount
        for k = 1:11
            if(spikes(j,i+k-1)==1) Ri(1,i) = Ri(1,i) + 1; end
        end
    end
 end
 
 figure(2);
 plot(1:990,Re);
 hold on;
 plot(1:990,Ri,'red');
 