model = SoutheastAlaskaMercatorModel();

% plot(scale(model.obstacles,1/model.visualScale),'FaceColor','black','FaceAlpha',1.0)

% Release near Berner's Bay
% x0 = 99000*ones(20,1);
% y0 = 60000*ones(20,1);

% Release near Glacier Bay
x0 = 41e3*ones(20,1);
y0 = 9e3*ones(20,1);

FigureSize = [50 50 350 230];
fig1 = figure('Units', 'points', 'Position', FigureSize);
set(gcf, 'Color', 'w');
fig1.PaperUnits = 'points';
fig1.PaperPosition = FigureSize;
fig1.PaperSize = [FigureSize(3) FigureSize(4)];

kappa = 0;
integrator = AdvectionDiffusionIntegrator(model,kappa);

T = 4*86400;
dt = 864;

[t,x,y] = integrator.particleTrajectories(x0,y0,T,dt);

subplot(1,2,1)
model.plotVelocityField(0,1), hold on
model.plotTrajectories(x,y,'LineWidth',1.5)
axis equal
xlim([-30 60])
ylim([-30 90])

kappa = 20;
integrator = AdvectionDiffusionIntegrator(model,kappa);

T = 4*86400;
dt = 864;

[t,x,y] = integrator.particleTrajectories(x0,y0,T,dt);

subplot(1,2,2)
model.plotVelocityField(0,1), hold on
model.plotTrajectories(x,y,'LineWidth',1.5)
axis equal
xlim([-30 60])
ylim([-30 90])

packfig(1,2)

tightfig
print('-dpng', '-r300', 'TrajectoriesWithAndWithoutDiffusion.png')