function [particles] = seedParticles(ini,floor)

start.North = ((randn(ini.n_particles,1))*ini.TwoDstd) + ini.north; % Normal distribution of north ini errors
start.East = ((randn(ini.n_particles,1))*ini.TwoDstd) + ini.east; % Normal distribution of east ini errors

start.Lat = ini.origin.lat + m_to_lat(start.North,ini.origin.lat);
start.Lon = ini.origin.lon + m_to_lon(start.East,ini.origin.lat); 

start.Heading = ((randn(ini.n_particles,1))*ini.HeadingStd) + ini.Heading;  % Normal distribution of heading errors
start.Level = 1 * ones(ini.n_particles,1);

start.Weight = 1 * ones(ini.n_particles,1);
start.Weight = start.Weight ./ sum(start.Weight);

particles = [start.North start.East start.Level start.Heading];

particles(:,5) = 0;

[particles] = updatePoly(particles,floor{1});

particles = [particles start.Weight];

particles(:,7) = ((randn(ini.n_particles,1))*ini.HeadingDrift) + 1;