function [observation] = GetGNSSNmea(observation)

global ini

fid = fopen(ini.fgnss);

i=1;
tline = fgetl(fid);
while ischar(tline)
    lines{i} = tline;
    tline = fgetl(fid);
    i = i + 1;
end

j=1;
for i = 1:length(lines)

    tline = lines{i};
    [data,ierr]  =  nmealineread(tline);
    
    if ierr == 0
        NMEAParsed(j,1)     = data.BODCTime;
        NMEAParsed(j,2)     = data.latitude;
        NMEAParsed(j,3)     = data.longitude;
        NMEAParsed(j,4)     = data.GPSFix;
        NMEAParsed(j,5)     = data.nSats;
        NMEAParsed(j,6)     = data.HDOP;
        
        j=j+1;
    end

end


    NMEAParsed((NMEAParsed(:,4)==0),:) = [];
 NMEAParsed(:,1) = (NMEAParsed(:,1).*(24*3600)) - ini.GNSStoIMUtime;
 
 for i = 2:length(observation)
    
     beforeThisObs = find(NMEAParsed(:,1)<observation(i).INStime);
     afterLastObs = find(NMEAParsed(:,1)>observation(i-1).INStime);
     temp = intersect(beforeThisObs,afterLastObs);
     temp = NMEAParsed(temp,:);
     
     if ~isempty(temp)
         observation(i).GNSS.Lat = mean(temp(:,2));
         observation(i).GNSS.Lon = mean(temp(:,3)); 
         observation(i).GNSS.HDOP = mean(temp(:,6));
         
         dlat = observation(i).GNSS.Lat - ini.origin.lat;
         dlon = observation(i).GNSS.Lon - ini.origin.lon;
         observation(i).GNSS.x = lon_to_m(dlon,ini.origin.lat);
         observation(i).GNSS.y = lat_to_m(dlat,ini.origin.lat);
     end
     
 end
 
 
 
 