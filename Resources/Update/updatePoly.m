function [particles] = updatePoly(particles,floor)

            
            inPolyOut = zeros(size(particles,1),size(floor.polys,2));  
            for j = 1:size(floor.polys,2)     
                in = inpoly([particles(:,2) particles(:,1)],floor.polys{j}.coords(:,1:2));
                inPolyOut(:,j) = in;
            end
            
            for i = 1:size(particles,1)
                temp=[];
                temp = find(inPolyOut(i,:)==1);
                if ~isempty(temp)
                    particles(i,5) = max(temp);
                else
                    particles(i,5) = -1;
                end
            end
            
end