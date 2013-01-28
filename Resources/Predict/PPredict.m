function [particles] = PPredict(particles,obs)

global ini

for i = 1:ini.n_particles

    meas = [obs.Distance + (randn(1)*ini.DistanceStd) + 0.05; 0];
   
    particles(i,4) = particles(i,4) + ( (particles(i,7)*obs.DeltaHeading) + randn(1)*ini.DeltaHeadingStd); %NEEDS NOISE ADDING?

    if particles(i,4) > 360
        particles(i,4) = particles(i,4) - 360;
    elseif particles(i,4) < 0
        particles(i,4) = particles(i,4) + 360;
    end    
    heading = particles(i,4);
    a = cosd(heading);
    b = sind(heading);
    rotm = [a -b;b a];
    meas = (rotm * meas)';
    particles(i,1) = particles(i,1) + meas(1);
    particles(i,2) = particles(i,2) + meas(2);
    
%     dlat = m_to_lat(meas(1),ini.origin.lat);
%     dlon = m_to_lon(meas(2),ini.origin.lat);
%     
%     particles(i,1:2) = particles(i,1:2) + [dlat dlon];
    
end