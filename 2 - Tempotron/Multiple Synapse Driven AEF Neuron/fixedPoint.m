%% Implementation of fixed-point method to determine the initialization values
function estimate = fixedPoint(stoppingCriteria, DelT, gL, a, EL, VT)

    Llower = VT - DelT*(log((gL+a)/gL));
    Lupper = VT + DelT*(log((gL+a)/gL));
    
    iterationInput = Llower + (Llower-Lupper)*rand(1);
    iterationOutput = g(iterationInput, gL, a, EL, VT, DelT);
    gPrime = 0;
    
    while((abs(iterationOutput - iterationInput))>stoppingCriteria)
        iterationInput = iterationOutput;
        iterationOutput = g(iterationInput, gL, a, EL, VT, DelT);
        gPrime = (gL/(gL+a))*(exp((iterationInput-VT)/DelT));
    end

    if(abs(gPrime)<1)
        estimate = iterationOutput;
    else
        fprintf('Equation is not suitable for fixed point iteration');
        estimate=0;
        return
    end
        
end


function value = g(x, gL, a, EL, VT, DelT)
    value = ((gL*DelT/(gL+a))*exp((x-VT)/DelT)) + EL;
end

