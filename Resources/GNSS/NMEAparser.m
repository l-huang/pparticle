[observation] = GetGNSSNmea(ini)

fid = fopen(ini.fnmea);

j=1;
for i = 1:1E4

    tline = fgetl(fid);
    try
        [data,ierr]  =  nmealineread(tline);
    catch
        ierr = 1;
    end
    if ierr == 0
        NMEAParsed.lat(j) = data.latitude;
        NMEAParsed.long(j) = data.longitude;
        NMEAParsed.time(j) = data.BODCTime;
        j=j+1;
        if  data.latitude==0
        'bob'
        end
    end

end