load('SoutheastAlaskaProjected.mat');

model = KinematicModel();

kappa = 20;
integrator = AdvectionDiffusionIntegrator(model,kappa);