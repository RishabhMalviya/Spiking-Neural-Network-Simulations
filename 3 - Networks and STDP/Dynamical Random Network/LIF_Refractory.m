%% membranePotential = LIF (Iapplied, timestep, dt, VT, EL);
% Iapplied is an array of size (number of neurons)x(number of timesteps)
% dt is the value of the timestep
% VT is the threshold voltage for spiking
% EL is the resting memebrane potential

function [membranePotential, spikeFlags] = LIF (Iapplied_prev, Iapplied, membranePotential, timestep, dt, VT, EL)
    
    % Prepare output variables
    N = size(Iapplied,1);
    spikeFlags = zeros(N,1);
    membranePotential(:,1) = membranePotential(:,2);
    membranePotential(:,2) = membranePotential(:,3);
    
      
    % Perform simulation
      % Determine V(n+1) from V(n) using 2nd order Runge-Kutta
      membranePotential(:,3) = rungeKuttaSecondOrder(membranePotential(:,2), dt, Iapplied_prev, Iapplied);

     for j = 1:N
          % Check for neurons that spiked or are in the refractory period
          if(timestep>=2)
              if((membranePotential(j,1)==VT)||(membranePotential(j,2)==VT)) membranePotential(j,3)=EL; end
          end
          % Check for neurons that have crossed threshold. V(t)->spike
          if(membranePotential(j,3) >= VT) 
              membranePotential(j,3)=VT;
              spikeFlags(j,1) = 1;
          end
     end
     
end

%% Getting V(n+1) from V(n) and I(n): the Runge-Kutta iterations
function Vn1 = rungeKuttaSecondOrder(Vn, dt, I1, I2)
    Vn_1 = zeros(size(Vn)); %Intermediate value, used to calculate k2
     
    Vn_1 = (f(Vn,I1))*dt + Vn; %Get intermediate value using k1
    Vn1 = (((f(Vn_1,I2))+(f(Vn,I1)))/2)*dt + Vn; %V(n+1) from k1 and k2
end


%% The 'f' from the differential equation x' = f(x,t)
function value = f(V,I);
    value = (I - (30*(10^(-9)))*(V + (70*(10^(-3)))))/(300*(10^(-12)));
end