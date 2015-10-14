Iapp = 150e-12;
dt = 1e-4;


for i =1:3
    mp(i,:) = AEF('RS', Iapp + i*(100e-12), dt);
end

createfigure(dt*1000:dt*1000:500, mp(1,:), mp(2,:), mp(3,:));


for i =1:3
    mp(i,:) = AEF('IB', Iapp + i*(100e-12), dt);
end

createfigure(dt*1000:dt*1000:500, mp(1,:), mp(2,:), mp(3,:));


for i =1:3
    mp(i,:) = AEF('CH', Iapp + i*(100e-12), dt);
end

createfigure(dt*1000:dt*1000:500, mp(1,:), mp(2,:), mp(3,:));
