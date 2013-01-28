function [floor] = loadPolys(fkml)

global ini

doc = xmlread(fkml); 

i = 1;
j = 1;
k = 0;
stop = false;
while stop == false
    c = doc.getElementsByTagName('coordinates').item(k);
    if isempty(c)
        stop = true;
        break
    end
    a = c.getChildNodes;
    b = a.getTextContent;
    b = char(b);

    b = strread(b,'%f','delimiter',',');
    b = reshape(b,3,(size(b,1)/3));
    b = b';

        if size(b,1) > 2
            floor.polys{i}.coords(:,1) = lon_to_m(b(:,1)-ini.origin.lon,ini.origin.lat);
            floor.polys{i}.coords(:,2) = lat_to_m(b(:,2)-ini.origin.lat,ini.origin.lat);
            floor.polys{i}.coords(:,3) = 0;
            i = i+1;
        elseif size(b,1) == 1
            floor.doors(j,1) = lon_to_m(b(1)-ini.origin.lon,ini.origin.lat);
            floor.doors(j,2) = lat_to_m(b(2)-ini.origin.lat,ini.origin.lat);
            floor.doors(j,3) = 0;
            j = j+1;
        end
        k=k+1;
end

k = 0;
j = 1;
stop = false;
while stop == false
    c = doc.getElementsByTagName('description').item(k);
    if isempty(c)
        stop = true;
        break
    end
    a = c.getChildNodes;
    b = a.getTextContent;
    b = char(b);
    b = strread(b,'%s','delimiter','{ }');
    
    for i=1:length(b)
       
        if strcmp(b{i},'RoomNo')
            floor.polys{k+1}.RoomNo = str2double(b{i+1});
        elseif strcmp(b{i},'Doors')
            floor.polys{k+1}.Doors = strread(b{i+1},'%f','delimiter',';');
        elseif strcmp(b{i},'Floor')
            floor.polys{k+1}.FloorNo = str2double(b{i+1});
        elseif strcmp(b{i},'Ele')
            floor.polys{k+1}.EleCng = str2double(b{i+1});
        end
        
    end
    k=k+1;
end

