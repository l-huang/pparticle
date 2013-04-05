function [particles] = PUpdate(particles,particles_old,floor)

global ini

for i = 1:ini.n_particles

    % If particle is in a room, get those walls, if not then get the
    % external walls.
    if particles(i,5) > 0
        wallsToCross = floor{1}.polys{particles(i,5)}.edges;
        polyNo = particles(i,5);
    else
        wallsToCross = floor{1}.polys{1}.edges;
        polyNo = 1;
    end
       
    particles(i,6) = 0;
        
    segment = [particles_old(i,2) particles_old(i,1) particles(i,2) particles(i,1)]; %[x1 y1 x2 y2]
    out = lineSegmentIntersect(segment,wallsToCross);

    if sum(out.intAdjacencyMatrix) == 1
        particles(i,6) = 0;
        % Which wall??
        PolyWallNo = find(out.intAdjacencyMatrix,1);
        % Is there a door
        if isfield(floor{1}.polys{polyNo},'door2wall')
            if sum(ismember(floor{1}.polys{polyNo}.door2wall,PolyWallNo)) > 0

                x = out.intMatrixX(out.intAdjacencyMatrix);
                y = out.intMatrixY(out.intAdjacencyMatrix);
                x = x(1); 
                y = y(1);

                DoorNo = (floor{1}.polys{polyNo}.door2wall == PolyWallNo);
                DoorNo = floor{1}.polys{polyNo}.Doors(DoorNo);

                x = abs(floor{1}.doors(DoorNo,1)) - abs(x);
                y = abs(floor{1}.doors(DoorNo,2)) - abs(y);
                d = hypot(x,y);

                DoorNo = DoorNo(d == min(d));
                d = min(d);
                
                if d < 0.5 %Door is nearby, go throught it and update polygon No
                    temp = floor{1}.doorPolygons(DoorNo,2:3);
                    temp = temp + 1; 
                    particles(i,5) = temp(temp~=particles(i,5));
%                     particles(i,6) = particles_old(i,6);
                    %Check new Polygon no
                    if particles(i,5) > 0
                        in = inpoly([particles(i,2) particles(i,1)],floor{1}.polys{particles(i,5)}.coords(:,1:2));
                        if in == 1
                            particles(i,6) = particles_old(i,6);
%                         else
%                             fprintf('FAIL \n')
                        end
                    else
                        particles(i,6) = particles_old(i,6);
                    end
                    
                end

            end
            
        end
        
    elseif sum(out.intAdjacencyMatrix) > 1
        
        particles(i,6) = 0;
    
    else
        
        particles(i,6) = particles_old(i,6);
        
    end

%% ReWeight (CHAIN, ignore for Pi


if particles(i,6) ~= 0 && ini.UseCardinal == true
    d = ini.Cardinal - particles(i,4);
    d = abs(d);
    if min(d) > 45
        d = d-90;
    end
%     particles(i,6) = particles(i,6) + normpdf(min(abs(d)),0,cardinalConfidence);
    particles(i,6) = normpdf(min(abs(d)),0,ini.Cardinalconfidence);
%     needsResampling = true;
end
    
end