load('problemOne1.mat');
NetworkSolver;
createfigureSpikes(time(1,:),spikes(1,:),spikes(2,:),spikes(5,:),'Neuron Spikes - Case 1');
createfigureCurrents(time(1,:),Iapplied(1,:),Iapplied(2,:),Iapplied(5,:), 'Incoming Neuron Currents - Case 1');
clear
clc

load('problemOne2.mat');
NetworkSolver;
createfigureSpikes(time(1,:),spikes(1,:),spikes(2,:),spikes(5,:), 'Neuron Spikes - Case 2');
createfigureCurrents(time(1,:),Iapplied(1,:),Iapplied(2,:),Iapplied(5,:), 'Incoming Neuron Currents - Case 2');
clear
clc

