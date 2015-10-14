load('LIF.mat');



mp = LIF(Iapplied,dt,VT,EL);



avg = zeros(10,5);
num = zeros(10,1);

for k = 1:10
    for i = 1:5000
        if(mp(k,i)==VT)
            avg(k,1) = avg(k,2);
            avg(k,2) = i;
            avg(k,3) = avg(k,2) - avg(k,1);
            avg(k,4) = avg(k,4) + avg(k,3);
            num(k,1) = num(k,1) + 1;
        end
    end
end

for i = 1:10
    avg(i,5) = avg(i,4)/num(i,1);
end

createfigure1(avg(:,5));



clear i k num;