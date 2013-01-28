function [particles LocalPolygons needResample] = PUpdateEdinPoly(particles,particles_old,floor)

global ini

% kill by default
particles(:,6) = 0;

% Get Local Polygons
        
    meanPosn.x = mean(particles(:,2));
    meanPosn.y = mean(particles(:,1));
    
%     meanPosn.x = -500;
%     meanPosn.y = 0;
    
    LocalPolygons = zeros(length(floor{1}.polys),1);
    for n = 1:length(floor{1}.polys)
        c = floor{1}.polys{n}.coords;
        c(:,4) = hypot( (c(:,1)-meanPosn.x),(c(:,2)-meanPosn.y));
        if min(c(:,4)) < 50
            LocalPolygons(n) = 1;
        end
    end
    LocalPolygons = find(LocalPolygons==1);
    LocalPolygons(LocalPolygons==355) = [];

% For each particle, check to see if this is a pre-visited grid square. 

% If there is take it's polygon value

% If not then do inpoly test for all local polygons. 