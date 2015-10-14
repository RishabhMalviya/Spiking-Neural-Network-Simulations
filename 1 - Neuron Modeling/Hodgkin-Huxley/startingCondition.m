function estimate = startingCondition()

    C = 1e-2;
    ENa = 50e-3;
    EK = -77e-3;
    El = -55e-3;
    gNa = 1200;
    gK = 360;
    gl = 3;

    iterationInput = -652e-4;
    iterationOutput = 0;

    iterationOutput = gNa*((x(iterationInput,'m'))^3)*(x(iterationInput,'h'))*(iterationInput-ENa) + gK*((x(iterationInput,'n'))^4)*(iterationInput-EK) + gl*(iterationInput-El);
    i = 0;
    while((abs(iterationOutput))>1e-6)
        iterationOutput = gNa*((x(iterationInput,'m'))^3)*(x(iterationInput,'h'))*(iterationInput-ENa) + gK*((x(iterationInput,'n'))^4)*(iterationInput-EK) + gl*(iterationInput-El);
        iterationInput = iterationInput + 1e-6;
        i = i+1;
    end
    
    estimate = iterationInput;

end

% x's (m, n, h);
function value = x(V, type)
    switch type
        case 'n'
            value = (alpha_n(V))/(alpha_n(V) + beta_n(V));
        case 'm'
            value = (alpha_m(V))/(alpha_m(V) + beta_m(V));
        case 'h'
            value = (alpha_h(V))/(alpha_h(V) + beta_h(V));
    end
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


