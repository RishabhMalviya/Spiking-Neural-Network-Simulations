function membranePotential = AEF (neuronType, Iapp, dt)
    % Choosing neuron type based on user input
    switch neuronType
        case 'RS'
            C = 200e-12;
            gL = 10e-9;
            EL = -70e-3;
            VT = -50e-3;
            DelT = 2e-3;
            a = 2e-9;
            tw = 30e-3;
            b = 0e-12;
            Vr = -58e-3;
        case 'IB'
            C = 130e-12;
            gL = 18e-9;
            EL = -58e-3;
            VT = -50e-3;
            DelT = 2e-3;
            a = 4e-9;
            tw = 150e-3;
            b = 120e-12;
            Vr = -50e-3;
        case 'CH'
            C = 200e-12;
            gL = 10e-9;
            EL = -58e-3;
            VT = -50e-3;
            DelT = 2e-3;
            a = 2e-9;
            tw = 120e-3;
            b = 100e-12;
            Vr = -46e-3;
        otherwise
            fprintf(neuronType); fprintf(' is an invalid neuron type. Exiting program.');
            return
    end
    
    % Initializing V(t) and U(t)
    Iapp = Iapp';
    V = zeros(size(Iapp,1),1); V(1) = fixedPoint(1e-6, DelT, gL, a, EL, VT);
    U = zeros(size(Iapp,1),1); U(1) = a*(V(1)-EL);
      
    % Perform simulation
    for i = 2:size(V,1)
        % Determine V(n+1) from V(n) using 4th order Runge-Kutta
        [V(i), U(i)] = eulerMethod(V(i-1), U(i-1), dt, (Iapp(i)+Iapp(i-1))/2, C, gL, EL, VT, DelT, a, tw);
        % Check if the neuron peaked in the previous iteration. V(t)->c,
        % U(t)->U(t) + d
        if(V(i-1)==0) 
            V(i) = Vr;
            U(i) = U(i-1) + b;
        end
        % Check if the neuron crossed zero. V(t)->0
        if(V(i)>=0) 
            V(i) = 0; 
        end
    end
    
    membranePotential = V;
    
end


%% Getting V(n+1) and U(n+1) from V(n) and U(n): the Runge-Kutta iterations
function [V1, U1] = eulerMethod(V, U, dt, Iapp, C, gL, EL, VT, DelT, a, tw);
    V1 = V + (1/C)*(gL*(DelT*(exp((V-VT)/DelT)) + EL - V) - U + Iapp)*dt;
    U1 = U + (1/tw)*(a*(V - EL) - U)*dt;
end

