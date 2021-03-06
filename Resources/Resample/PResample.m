function [particles,FilterFail] = PResample(particles, particles_old,stepNo,needResample)

if needResample == true;

%% Resample

    % Normalise Weights
    particles(:,6) = particles(:,6)./sum(particles(:,6));
%     indx = particles(:,6) > 0;
%     particles(indx,6) = particles(indx,6) + particles_old(indx,6);
%     particles(:,6) = particles(:,6)./sum(particles(:,6));

    if sum(particles(:,6)) == 0
        fprintf('Filter Failed \n')
        FilterFail = true;
        return
    elseif sum(isnan(particles(:,6))) > 0
        fprintf('Filter Failed isNan \n')
        FilterFail = true;
        return
    else
        FilterFail = false;
    end
    
    [particles] = reSampleMN(particles,stepNo);  

else
    
    [particles] = UpdateHistory(particles,stepNo);
    FilterFail = false;

end
