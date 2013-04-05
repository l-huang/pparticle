clear
clear global
close all

addpath 'Resources/Utils'
addpath 'Resources/Initialise'
addpath 'Resources/Output'
addpath 'Resources/Predict'
addpath 'Resources/Update'
addpath 'Resources/Resample'
% addpath 'Resources/GNSS'

global ParticleHistories
baseDir = pwd;

%% Open control file

LoadINI

ctrlFile = importdata('G:\Projects\OI Trial\ctrlFile.txt');
nextLine = min(find(ctrlFile(:,4)==0));
participant = [['P'] [num2str(ctrlFile(nextLine,1))]];
trialNo = [ ['00'] [num2str(ctrlFile(nextLine,2))] ];
if length(trialNo) == 4
    trialNo(1) = [];
end

a = [['cd '] [''''] ['G:\data\OITrial_Jan2013\Participants'] ['\'] [participant] ['\'] [trialNo] ['\'] ['''']];

if ctrlFile(nextLine,3)==1
    ini.north = 28.7;
    ini.east = 39.7;
    ini.Heading = 0;
elseif ctrlFile(nextLine,3)==2
    ini.north = 43.4;
    ini.east = 39.7;
    ini.Heading = 0;
elseif ctrlFile(nextLine,3)==3
    ini.north = 43.4;
    ini.east = 54.5;
    ini.Heading = 0;
elseif ctrlFile(nextLine,3)==4
    ini.north = 28.7;
    ini.east = 52.7;
    ini.Heading = 0;
end
%% ini values

% a = [['cd '] [''''] [pwd] ['\'] ['SampleData'] ['''']];
% a = [['cd '] [''''] [pwd] ['\'] ['SampleData\Maze'] ['''']];
eval(a);

% LoadINI

ini.fins = [[pwd] '\ins.txt'];
ini.HistoryOP = [[pwd] '\ParticleHistory.txt'];

a = [['cd '] [''''] [baseDir] ['\'] ['''']];
eval(a);

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

%% Output

[posn] = getHistory(ini,observation);

ctrlFile(nextLine,4) = 1;
if FilterFail == true
    ctrlFile(nextLine,5) = 1;
end

fid = fopen('G:\Projects\OI Trial\ctrlFile.txt','w');
for i = 1:size(ctrlFile,1)
    fprintf(fid,'%i,%i,%i,%i,%i \n',ctrlFile(i,:)); 
end

fclose all








%% END


