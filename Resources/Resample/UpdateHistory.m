function [particles] = UpdateHistory(particles,stepNo)

global ParticleHistories
global ini

for i = 1:ini.n_particles
    ParticleHistories(i,stepNo).x = particles(i,1);
    ParticleHistories(i,stepNo).y = particles(i,2);
end

