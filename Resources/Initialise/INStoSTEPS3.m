function [observation, posn] = INStoSTEPS3(ini)
% clear

% addpath 'C:\Users\pszjp\Documents\MATLAB\Usefull'

% fins = 'G:\data\EdinDump\Walk2-HolyroodtoGeog\IMU\ins.txt';
% fzupt = 'G:\data\EdinDump\Walk2-HolyroodtoGeog\IMU\zupt.txt';
% origin.lat = [55.9512590000000;];
% origin.lon = [-3.16934400000000;];

global ParticleHistories

ins = importdata(ini.fins, '\t');

ins(:,5:9)=[];
ins(:,6:end)=[];

days = floor(ins(1,1) / (24*3600));
ins(:,1) = ins(:,1) - (days*(24*3600));

if ini.forward == false
   ins = flipdim(ins,1);    
end

for i=2:size(ins,1)
    
    dlat = ins(i,2) - ini.origin.lat;
    dlon = ins(i,3) - ini.origin.lon;
    
    ins(i,6) = lon_to_m(dlon, ini.origin.lat);
    ins(i,7) = lat_to_m(dlat, ini.origin.lat);
%     ins(i,8) = ins(i,5) - ins(i-1,5);
    
end

last = 1;
k=1;

for i=2:size(ins,1)
   
    dx = ins(i,6) - ins(last,6);
    dy = ins(i,7) - ins(last,7);
    distance = hypot(dx,dy);
    
    if distance > ini.filterUpdateDist
        step.length(k) = distance;% - (0.5*distance);
        step.x(k) = ins(i,6) - ins(last,6);
        step.y(k) = ins(i,7) - ins(last,7);
%         step.length2(k) = hypot(step.x(k),step.y(k));
        step.heading(k) = atan2(step.x(k),step.y(k));
%         step.heading(k) = ins(i,5);
        if k>1
            step.headingChange(k) = step.heading(k) - step.heading(k-1);
        else
            step.headingChange(k) = 0;
        end
        step.time(k) = ins(i,1);
        k = k + 1;
        last = i;
    end
    
end

%% Do EKF path for comparison

posn(1,:) = [0 0]; %
heading = zeros(1,k-1);
%heading = 120*(pi/180);

for i = 2:length(step.length)
    
    heading(i) = heading(i-1) + step.headingChange(i);
    
    deltaposn = [step.length(i) 0];  
    
    rotm = [cos(heading(i)) -sin(heading(i)); sin(heading(i)) cos(heading(i))];
    
    deltaposn = rotm' * deltaposn'; 
    posn(i,:) = posn(i-1,:) + deltaposn';
   
end

for i = 1:length(step.heading)
    observation(i).Heading = (180/pi).*step.heading(i);
    observation(i).DeltaHeading = (180/pi).*step.headingChange(i);
    observation(i).Distance = step.length(i);
    observation(i).INStime = step.time(i);
end
    
ParticleHistories(ini.n_particles,length(observation)).x = [];
ParticleHistories(ini.n_particles,length(observation)).y = [];



