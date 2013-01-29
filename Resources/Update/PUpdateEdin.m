function [particles LocalPolygons needResample] = PUpdateEdin(particles,particles_old,floor,observation)

global ini
usedGNSS = false;
needResample = false;

% kill by default
particles(:,6) = 0;

% Weight with GNSS

if isfield(observation,'GNSS')
    
    if ~isempty(observation.GNSS)
        
        for i = 1:ini.n_particles

            dx = particles(i,2) - observation.GNSS.x;
            dy = particles(i,1) - observation.GNSS.y;
            Perr = hypot(dx,dy);
            particles(i,6) = normpdf(Perr,0,10);
            needResample = true;
            usedGNSS = true;
            
        end
        
    end
    
end

if usedGNSS == true
    particles( (particles(:,6)<1E-7),6) = 0;
    fprintf('Used GNSS');
end

% Get Local Polygons
        
    meanPosn.x = mean(particles(:,2));
    meanPosn.y = mean(particles(:,1));
    
%     meanPosn.x = -500;
%     meanPosn.y = 0;
    
    LocalPolygons = zeros(length(floor{1}.polys),1);
    for n = 1:length(floor{1}.polys)
        c = floor{1}.polys{n}.coords;
        c(:,4) = hypot( (c(:,1)-meanPosn.x),(c(:,2)-meanPosn.y));
        if min(c(:,4)) < 250
            LocalPolygons(n) = 1;
        end
    end
    LocalPolygons = find(LocalPolygons==1);
    LocalPolygons(LocalPolygons==355) = [];

    % Get Walls
    wallsToCross = [];
    for n = 1:length(LocalPolygons)
       wallsToCross = [wallsToCross; floor{1}.polys{LocalPolygons(n)}.edges];
    end
   
    for i = 1:size(wallsToCross,1)
        wallsToCrossMaxX(i) = max( [wallsToCross(i,1) wallsToCross(i,3)]);
        wallsToCrossMinX(i) = min( [wallsToCross(i,1) wallsToCross(i,3)]);
        wallsToCrossMaxY(i) = max( [wallsToCross(i,2) wallsToCross(i,4)]);
        wallsToCrossMinY(i) = min( [wallsToCross(i,2) wallsToCross(i,4)]);
    end
    
    fprintf(',%i,',size(wallsToCross,1));
    
    if size(wallsToCross,1)>0
        
        steplength = 2;
        
        walls.MaxX = find(wallsToCrossMaxX < (min(particles(:,2))- steplength)); % Condition for rejecting wall
        walls.MinX = find(wallsToCrossMinX > (max(particles(:,2))+ steplength));
        walls.MaxY = find(wallsToCrossMaxY < (min(particles(:,1))- steplength));
        walls.MinY = find(wallsToCrossMinY > (max(particles(:,1))+ steplength));
        
        WallsToRemove = [walls.MaxX walls.MinX walls.MaxY walls.MinY];
        WallsToRemove = unique(WallsToRemove);
        wallsToCrossTemp = wallsToCross;
        wallsToCrossTemp(WallsToRemove,:) = [];
        
        fprintf(',%i,',size(wallsToCrossTemp,1));
        
        if size(wallsToCrossTemp,1)>0
        
            for i=1:size(wallsToCrossTemp,1)
                hold on
                plot( [wallsToCrossTemp(i,1) wallsToCrossTemp(i,3)],[wallsToCrossTemp(i,2) wallsToCrossTemp(i,4)],'-xr')
            end
            
                for i = 1:ini.n_particles
                
                            segment = [particles_old(i,2) particles_old(i,1) particles(i,2) particles(i,1)]; %[x1 y1 x2 y2]
                            out = lineSegmentIntersect(segment,wallsToCrossTemp);
        
                            if sum(out.intAdjacencyMatrix) >0
                                particles(i,6) = 0;
                                needResample = true;
                            elseif particles(i,5) == -1
                                particles(i,6) = 0;
                                needResample = true;
                            elseif usedGNSS == false
                                particles(i,6) = 1;
                            end
    
                end
                    
                
        end
        
        
        
    else
        particles(:,6) = 0;
    end