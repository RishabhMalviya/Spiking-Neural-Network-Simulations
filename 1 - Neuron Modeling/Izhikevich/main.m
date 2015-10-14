Iapp = 300e-12;
dt = 1e-4;



for i =1:3
    [mp(i,:),U] = Izhikevich('RS',Iapp+i*100e-12,dt);
end

createfigure(dt*1000:dt*1000:500, mp(1,:), mp(2,:), mp(3,:));

for i =1:3
    [mp(i,:),U] = Izhikevich('IB',Iapp+i*100e-12,dt);
end

createfigure(dt*1000:dt*1000:500, mp(1,:), mp(2,:), mp(3,:));

for i =1:3
    [mp(i,:),U] = Izhikevich('CH',Iapp+i*100e-12,dt);
end

createfigure(dt*1000:dt*1000:500, mp(1,:), mp(2,:), mp(3,:));
