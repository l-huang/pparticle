function [floor] = LoadMapKML(fkml)



floor{1} = loadPolys(fkml);

%% IGNORE THIS BIT
% cardinalHeadings = [81];
% % cardinalHeadings = [90];
% % cardinalHeadings = [72];
% for i = 2:4
%     cardinalHeadings(i) = cardinalHeadings(i-1) + 90;
% end
% cardinalConfidence = 10;
% %
%

%% This bit of code does two things 
% %- reformats polgons in terms of walls (edges)
% %- associates doors with walls within a polygon eg floor{1}.polys{i}.door2wall(n)

for i = 1:length(floor{1}.polys)
    
    poly = floor{1}.polys{i}.coords(:,1:2);
    m = 1;
    floor{1}.polys{i}.edges = [poly(m,1) poly(m,2) poly(m+1,1) poly(m+1,2)];
    for m = 2:size(poly,1)-1;
        floor{1}.polys{i}.edges = [floor{1}.polys{i}.edges; poly(m,1) poly(m,2) poly(m+1,1) poly(m+1,2)];
    end
    floor{1}.polys{i}.edges = [floor{1}.polys{i}.edges; poly(1,1) poly(1,2) poly(end,1) poly(end,2)];
    
    if isfield(floor{1},'doors')
        Doors = floor{1}.doors(floor{1}.polys{i}.Doors,:);
            for n = 1:size(Doors,1)
                d = [];
                for m = 1:size(floor{1}.polys{i}.edges,1)
                    d(m) = point_to_line(Doors(n,1:2), [floor{1}.polys{i}.edges(m,1:2)], [floor{1}.polys{i}.edges(m,3:4)]);
                end
                floor{1}.polys{i}.door2wall(n) = find(d==min(d),1);
            end
%     else
%         floor{1}.doors = [NaN NaN NaN];
        
    end
end

if isfield(floor{1},'doors')
    
    floor{1}.doorPolygons = [1:length(floor{1}.doors)]';
    floor{1}.doorPolygons(:,2) = NaN;
    floor{1}.doorPolygons(:,3) = NaN;

    for i = 1:length(floor{1}.polys)

        if ~isempty(floor{1}.polys{i}.Doors)
       
            for j = 1:length(floor{1}.polys{i}.Doors)
    
                if isnan(floor{1}.doorPolygons(floor{1}.polys{i}.Doors(j),2))
                    floor{1}.doorPolygons(floor{1}.polys{i}.Doors(j),2) = i-1;
                elseif isnan(floor{1}.doorPolygons(floor{1}.polys{i}.Doors(j),3))
                    floor{1}.doorPolygons(floor{1}.polys{i}.Doors(j),3) = i-1;
                else
                    fprintf('Error - Door links more than two polygons \n')
                    return
                end
            
            end

        end
    
    end

    floor{1}.doorPolygons(isnan(floor{1}.doorPolygons)) = -1;

end
