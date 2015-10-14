load('problemOne.mat')

[spikeTrain, spikeTimes] = Stimulus(lambda, dt, T);
Iapplied = temporalSummation(spikeTimes, Io, we, taum, taus, dt);
membranePotential = LIF (Iapplied, dt, VT, EL);
%membranePotential = AEF('RS', Iapplied, dt);

t = dt:dt:T;
t = t*1000;

createfigure(t,spikeTrain,Iapplied,membranePotential);

clear;
clc;