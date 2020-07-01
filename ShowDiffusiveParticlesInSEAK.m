load('Data/SoutheastAlaskaProjected.mat');
[xlim,ylim] = boundingbox(SEAKProjectedPolygons(1));
for i=2:length(SEAKProjectedPolygons)
    [xlim2,ylim2] = boundingbox(SEAKProjectedPolygons(i));
    if xlim2(1) < xlim(1)
        xlim(1) = xlim2(1);
    end
    if xlim2(2) > xlim(2)
        xlim(2) = xlim2(2);
    end
    if ylim2(1) < ylim(1)
        ylim(1) = ylim(1);
    end
    if ylim2(2) > ylim(2)
        ylim(2) = ylim2(2);
    end
end


model = KinematicModel();
model.obstacles = SEAKProjectedPolygons;
model.xVisLim = xlim;
model.yVisLim = ylim;



x0 = 99000*ones(200,1);
y0 = 60000*ones(200,1);

kappa = 20;
integrator = AdvectionDiffusionIntegrator(model,kappa);

T = 86400;
dt = 864;

profile on
[t,x,y] = integrator.particleTrajectories(x0,y0,T,dt);
profile off


% profile_filename = sprintf('IntegratorWithObstaclesProfile_%s',datestr(datetime('now'), 'YYYY_mm_dd-HH:MM:SS'));
% profsave(profile('info'),profile_filename)

profile viewer

figure
plot(scale(model.obstacles,1e-3)), hold on
model.plotTrajectories(x,y,'LineWidth',1.5)