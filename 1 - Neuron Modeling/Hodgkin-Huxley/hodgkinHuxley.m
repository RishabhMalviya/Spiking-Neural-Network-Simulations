function [V,m,n,h] = hodgkinHuxley(Iapplied, dt)
    % Neuron parameters
    C = 1e-2;
    ENa = 50e-3;
    EK = -77e-3;
    El = -55e-3;
    gNa = 1200;
    gK = 360;
    gl = 3;

    % Prepare variables
    V = zeros(1,size(Iapplied,2));
    m = zeros(1,size(Iapplied,2));
    n = zeros(1,size(Iapplied,2));
    h = zeros(1,size(Iapplied,2));
    
    % Inititalize variables
    V(1) = -65155e-6;
    m(1) = (alpha_m(V(1)))/(alpha_m(V(1)) + beta_m(V(1)));
    n(1) = (alpha_n(V(1)))/(alpha_n(V(1)) + beta_n(V(1)));
    h(1) = (alpha_h(V(1)))/(alpha_h(V(1)) + beta_h(V(1)));
          
    % Perform simulation
    for i = 2:size(Iapplied,2)
        [V(i),m(i),n(i),h(i)] = rungeKuttaSecondOrder(V(i-1), m(i-1), n(i-1), h(i-1), dt, Iapplied(i-1), Iapplied(i), gNa, gK, gl, ENa, EK, El, C);
    end
    
end


function [V1,m1,n1,h1] = rungeKuttaSecondOrder(V, m, n, h, dt, I, I1, gNa, gK, gl, ENa, EK, El, C)
    [V_k1, m_k1, n_k1, h_k1] = f(V,m,n,h,I,gNa,gK,gl,ENa,EK,El,C);
    V_ = V_k1*dt + V; 
    m_ = m_k1*dt + m; 
    n_ = n_k1*dt + n; 
    h_ = h_k1*dt + h;
    
    [V_k2, m_k2, n_k2, h_k2] = f(V_,m_,n_,h_,I1,gNa,gK,gl,ENa,EK,El,C);
    V_k = (V_k1 + V_k2)/2;
    m_k = (m_k1 + m_k2)/2;
    n_k = (n_k1 + n_k2)/2;
    h_k = (h_k1 + h_k2)/2;
    

    V1 = V_k*dt + V;
    m1 = m_k*dt + m;
    n1 = n_k*dt + n;
    h1 = h_k*dt + h;
end


function [V1,m1,n1,h1] = f(V,m,n,h,I,gNa,gK,gl,ENa,EK,El,C)
    V1 = (1/C)*(I - (gNa*(m^3)*h*(V-ENa)) - (gK*(n^4)*(V-EK)) - (gl*(V-El)));
    m1 = (alpha_m(V)*(1-m) - beta_m(V)*m);
    n1 = (alpha_n(V)*(1-n) - beta_n(V)*n);
    h1 = (alpha_h(V)*(1-h) - beta_m(V)*h);
end

% Alphas
function value = alpha_m(V)
    value = (0.1*(V*1000+40))/(1-(exp(-((V*1000+40)/10))));
end


function value = alpha_n(V)
    value = 0.01*(V*1000 + 55)/(1 - (exp(-((V*1000+55)/10))));
end


function value = alpha_h(V)
    value = 0.07*(exp(-(0.05*(V*1000+65))));
end


% Betas
function value = beta_m(V)
    value = 4*(exp(-0.0556*(V*1000+65)));
end


function value = beta_n(V)
    value = 0.125*(exp(-((V*1000+65)/80)));
end


function value = beta_h(V)
    value = 1/(1 + (exp(-(0.1*(V*1000+35)))));
end

