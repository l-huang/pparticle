clear
clear global
close all

addpath 'C:\Users\pszjp\Documents\MATLAB\Usefull'
addpath 'Resources/Initialise'
addpath 'Resources/Output'
addpath 'Resources/Predict'
addpath 'Resources/Update'
addpath 'Resources/Resample'
addpath 'Resources/GNSS'

global ParticleHistories

%% ini values

addpath 'G:\data\JJ_001\Proc'
% cd 'G:\data\EdinDump\Walk2-HolyroodtoGeog\Proc'
LoadINI
% load 'BinaryMap.mat'
cd 'C:\Users\pszjp\Documents\MATLAB\ParticleFilters\PParticle'

%% Load Mapping

[floor] = LoadMapKML(ini.fkml);

%% Get path from INS

[observation, posn] = INStoSTEPS3(ini);

%% Get path from GNSS

if isfield(ini,'fgnss')
  [observation] = GetGNSSNmea(observation);  
end

%% Initialise Particles

[particles] = seedParticles(ini,floor);

%% Loop

for k = 2:(length(observation))
% for k = 2:15
 
    tic
    particles_old = particles;
    
    %% Predict

    [particles] = PPredict(particles,observation(k));
    
    %% Update

    [particles] = PUpdate(particles,particles_old,floor);
    needResample = true;
%       [particles LocalPolygons needResample] = PUpdateEdin(particles,particles_old,floor,observation(k));
    
    %% Resample

    [particles, FilterFail] = PResample(particles,particles_old,k, needResample);
    
    if FilterFail == true
        fprintf('Filter Stopped, Failure \n')
        return
    end
    
    %% Store / Plot
    
    fprintf('Epoch %i \n',k)
    
    fig = 'figure(1)';
    eval(fig)
    if k == 2
       plotParticles(fig,floor{1});
       part_handle = plot(particles(:,2),particles(:,1),'xb');
    else
        delete(part_handle)
        part_handle = plot(particles(:,2),particles(:,1),'xb');
%         axis([mean(particles(:,2))-200 mean(particles(:,2))+200 mean(particles(:,1))-200 mean(particles(:,1))+200])
    end
% 
%     figure(1)
%     hold on
%     part_handle = plot(particles(:,2),particles(:,1),'xb');
%     if isfield(observation,'GNSS')
%         if ~isempty(observation(k).GNSS)
%             plot(observation(k).GNSS.x,observation(k).GNSS.y,'og') 
%         end
%     end
%     axis([mean(particles(:,2))-200 mean(particles(:,2))+200 mean(particles(:,1))-200 mean(particles(:,1))+200])
end

