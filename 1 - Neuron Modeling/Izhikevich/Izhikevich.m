function [membranePotential, U] = Izhikevich (neuronType, Iapp, dt)
    % Choosing neuron type based on user input
    switch neuronType
        case 'RS'
            C = 1e-10;
            kz = 7e-7;
            Er = -60e-3;
            Et = -40e-3;
            a = 30;
            b = -2e-9;
            c = -50e-3;
            d = 1e-10;
            Vpeak = 35e-3;
        case 'IB'
            C = 150e-12;
            kz = 1.2e-6;
            Er = -75e-3;
            Et = -45e-3;
            a = 10;
            b = 5e-9;
            c = -56e-3;
            d = 130e-12;
            Vpeak = 50e-3;
        case 'CH'
            C = 50e-12;
            kz = 1.5e-6;
            Er = -60e-3;
            Et = -40e-3;
            a = 20;
            b = 1e-9;
            c = -40e-3;
            d = 150e-12;
            Vpeak = 25e-3;
        otherwise
            fprintf(neuronType); fprintf(' is an invalid neuron type. Exiting program.');
            return
    end
    
    % Initializing V(t) and U(t)
    V = zeros(500/(dt*1000),1); V(1) = (b/kz) + Et;
    U = zeros(500/(dt*1000),1); U(1) = b*((b/kz) + Et - Er);
      
    % Perform simulation
    for i = 2:size(V,1)
        % Determine V(n+1) from V(n) using 4th order Runge-Kutta
        [V(i), U(i)] = rungeKuttaFourthOrder(V(i-1), U(i-1), dt, Iapp, C, kz, Er, Et, a, b);
        % Check if the neuron peaked in the previous iteration. V(t)->c,
        % U(t)->U(t) + d
        if(V(i-1)==Vpeak) 
            V(i) = c; 
            U(i) = U(i-1) + d;
        end
        % Check if the neuron crossed the threshold. V(t)->Vpeak
        if(V(i)>=Vpeak) 
            V(i) = Vpeak; 
        end
    end
    
    membranePotential = V;
    
end

%% Getting V(n+1) and U(n+1) from V(n) and U(n): the Runge-Kutta iterations
function [V1,U1] = rungeKuttaFourthOrder(V, U, dt, Iapp, C, kz, Er, Et, a, b)
    k = zeros(4,1); l = zeros(4,1); % For storing the computed k_i's and l_i's
    
    % Compute the k_i's and l_i's
    k(1) = f(V, U, Iapp, kz, Er, Et, C); 
    l(1) = g(V, U, a, b, Er);
    
    k(2) = f(V +((dt/2)*k(1)), U + ((dt/2)*l(1)), Iapp, kz, Er, Et, C); 
    l(2) = g(V +((dt/2)*k(1)), U + ((dt/2)*l(1)), a, b, Er);
    
    k(3) = f(V +((dt/2)*k(2)), U + ((dt/2)*l(2)), Iapp, kz, Er, Et, C); 
    l(3) = g(V +((dt/2)*k(2)), U + ((dt/2)*l(2)), a, b, Er);
    
    k(4) = f(V +((dt)*k(3)), U + ((dt)*l(3)), Iapp, kz, Er, Et, C); 
    l(4) = g(V +((dt)*k(3)), U + ((dt)*l(3)), a, b, Er);
    
    % Use the k_i's and l_i's to calculate the output
    V1 = V + ((k(1) + 2*k(2) + 2*k(3) + k(4))/6)*dt;
    U1 = U + ((l(1) + 2*l(2) + 2*l(3) + l(4))/6)*dt;
end


%% The 'f' from the differential equation V' = f(V,U,I)
function value = f(V, U, I, kz, Er, Et, C);
    value = ((kz*(V-Er)*(V-Et)) - U + I)/C;
end


%% The 'g' from the differential equation U' = g(V,U,I)
function value = g(V, U, a, b, Er)
    value = a*(b*(V-Er) - U);
end
