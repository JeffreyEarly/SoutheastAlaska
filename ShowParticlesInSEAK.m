model = SoutheastAlaskaMercatorModel();

% plot(scale(model.obstacles,1/model.visualScale),'FaceColor','black','FaceAlpha',1.0)

% Release near Berner's Bay
% x0 = 99000*ones(20,1);
% y0 = 60000*ones(20,1);

% Release near Glacier Bay
x0 = 41e3*ones(20,1);
y0 = 9e3*ones(20,1);

kappa = 20;
integrator = AdvectionDiffusionIntegrator(model,kappa);

T = 4*86400;
dt = 864;

[t,x,y] = integrator.particleTrajectories(x0,y0,T,dt);


figure
% plot(scale(model.obstacles,1e-3)), hold on
model.plotVelocityField(0), hold on
model.plotTrajectories(x,y,'LineWidth',1.5)
axis equal
xlim([-40 80])
ylim([-30 90])

% print('-dpng', '-r300', 'TrajectoriesWithDiffusion.png')