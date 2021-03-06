function [particles] = reSampleMN(particles,stepNo)

global ParticleHistories
global ini

a = particles(:,6);
Q = cumsum(a);
M = length(Q);

i=1;
while (i<=M),
    
    sampl = rand(1,1);  % (0,1]
    clear temp
    temp = find(Q>sampl);
    if ~isempty(temp)
       indx(i) = temp(1);
    else
       indx(i) = 1;  
    end
    i=i+1;

end

particles_old = particles;

for i = 1:ini.n_particles
    ParticleHistories(i,stepNo).x = particles(i,1);
    ParticleHistories(i,stepNo).y = particles(i,2);
end
ParticleHistories_old = ParticleHistories;

for i = 1:length(indx) 
    particles(i,:) = particles_old(indx(i),:);    
    ParticleHistories(i,:) = ParticleHistories_old(indx(i),:);
end
