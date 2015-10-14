load('problemTwo.mat');
load('spikes.mat');
%[spikeTrain, spikeTimes] = Stimulus(Ns, lambda, dt, T);


wo=50;
sigmaw=5;
weights(1:100,1)=(wo+sigmaw*randn(100,1));
Iapplied = temporalSummation(spikeTimes, Io, weights, taum, taus, dt);
Iapp=sum(Iapplied);
membranePotential = AEF('RS', Iapp, dt);

createfigureA(t,Iapp,membranePotential);


wo=250;
sigmaw=25;
weights(1:100,1)=(wo+sigmaw*randn(100,1));
Iapplied = temporalSummation(spikeTimes, Io, weights, taum, taus, dt);
Iapp=sum(Iapplied);
membranePotential = AEF('RS', Iapp, dt);

createfigureB(t,Iapp,membranePotential);


clear;
clc;
