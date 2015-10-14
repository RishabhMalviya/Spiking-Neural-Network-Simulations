%% membranePotential = LIF (Iapplied, dt, VT, EL);
% Iapplied is an array of size (number of neurons)x(number of timesteps)
% dt is the value of the timestep
% VT is the threshold voltage for spiking
% EL is the resting memebrane potential

function membranePotentials = LIF (Iapplied, dt, VT, EL)
    
    % Prepare output variables
    membranePotentials = zeros(size(Iapplied));
    membranePotentials(:,1) = EL;
    
    % Number of neurons, number of iterations
    N = size(Iapplied,1);
    M = size(Iapplied,2);
      
    % Perform simulation
    for i = 2:M
        % Determine V(n+1) from V(n) using 2nd order Runge-Kutta
        membranePotentials(:,i) = rungeKuttaSecondOrder(membranePotentials(:,i-1), dt, Iapplied(:,i-1), Iapplied(:,i));
        % Check for neurons that spiked in the previous iteration. V(t)->EL
        for j = 1:N
            if(membranePotentials(j,i-1)==VT) membranePotentials(j,i)=EL; end
        end
        % Check for neurons that have crossed threshold. V(t)->spike
        for j = 1:N
            if(membranePotentials(j,i) >= VT) membranePotentials(j,i)=VT; end
        end 
    end
    
    % Plot responses of neurons 2, 4, 6, and 8
    createfigure(dt*1000:dt*1000:500,membranePotentials(2,:),membranePotentials(4,:),membranePotentials(6,:),membranePotentials(8,:));    
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