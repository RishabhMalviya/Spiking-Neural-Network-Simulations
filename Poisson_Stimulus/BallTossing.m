%%Simulates ball tossing experiment and compares with corresponding Poisson Distribution. 
function BallTossing(balls, buckets)

%Array containing values for P_k(m)
pk = zeros(1,balls);

%Parameter for Poisson Distribution
lambda = balls/buckets;


%Simulate ball-tossing
for i = 1:1000000
    tally = zeros(1,buckets);
    run = ceil(buckets*rand(1,balls));
    
    for j = 1:balls
        tally(1,run(1,j)) = tally(1,run(1,j)) + 1;
    end
    
    for j = 1:balls
        for k = 1:buckets
            if(tally(1,k)==j) pk(1,j) = pk(1,j) + 1; end
        end
    end
    
end

%Normalisation of values in P_k(m) for comparison with Poisson Distribution
pk(1,:) = pk(1,:)/(sum(pk));



%Generate equivalent Poisson distribution
for i = 1:balls
    poisson(1,i) = ((exp(-(lambda)))*(lambda^i))/(factorial(i));
end


%Plot
plot(1:balls, pk(1,:), 'blue');
hold on
plot(1:balls, poisson(1,:), 'green');







