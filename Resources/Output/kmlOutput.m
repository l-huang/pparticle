% load history.mat
ini.origin.lat = [55.9512590000000;];
ini.origin.lon = [-3.16934400000000;];

fkml = 'G:\data\EdinDump\Walk2-HolyroodtoGeog\Proc\Histories.kml'; 
fkml_id = fopen(fkml,'w');

fprintf(fkml_id,'<?xml version="1.0" encoding="UTF-8"?> \n');
fprintf(fkml_id,'<kml> \n');

fprintf(fkml_id,'<Document> \n');
fprintf(fkml_id,'	<name>ParticleHistories</name> \n');
fprintf(fkml_id,'<Style id="footprint"> \n');
fprintf(fkml_id,'      <LineStyle> \n');
fprintf(fkml_id,'        <color>64000000</color> \n');
fprintf(fkml_id,'        <width>5</width> \n');
fprintf(fkml_id,'      </LineStyle> \n');
fprintf(fkml_id,'      <PolyStyle> \n');
fprintf(fkml_id,'        <color>641400FF</color> \n');
fprintf(fkml_id,'      </PolyStyle> \n');
fprintf(fkml_id,'    </Style> \n');


%% Foot Print

for i = 1:size(ParticleHistories,1)
    
    fprintf(fkml_id,'  <Placemark> \n');
    fprintf(fkml_id,'    <name> %i </name> \n',i);
    fprintf(fkml_id,'    <description>ParticleHistories,');
    fprintf(fkml_id,'    Forward');
    fprintf(fkml_id,'    </description> \n');
    fprintf(fkml_id,'       <Style> \n');
    fprintf(fkml_id,'     <LineStyle> \n');
    fprintf(fkml_id,'       <width>2</width> \n');
    fprintf(fkml_id,'       <color>ff0000ff</color> \n');
    fprintf(fkml_id,'     </LineStyle> \n');
   fprintf(fkml_id,'    </Style> \n');
    fprintf(fkml_id,'   <LineString id="POINT string"> \n');
    fprintf(fkml_id,'   <extrude>0</extrude> \n');
    fprintf(fkml_id,'   <tessellate>0</tessellate> \n');
    fprintf(fkml_id,'   <altitudeMode>clampToGround</altitudeMode> \n');
    fprintf(fkml_id,'   <coordinates> \n');
    
    for j = 1:size(ParticleHistories,2)
        try
        if ~isempty(ParticleHistories(i,j).y) && ~isempty(ParticleHistories(i,j).x)
            lat = ParticleHistories(i,j).x;
            lon = ParticleHistories(i,j).y;
            lat = ini.origin.lat + m_to_lat(lat,ini.origin.lat);
            lon = ini.origin.lon + m_to_lon(lon,ini.origin.lat);
            h = 0;
            fprintf(fkml_id,'%f,%f,0 \n',lon, lat);  
        end
        catch
            'bob';
        end
    end
 
    fprintf(fkml_id,'       </coordinates> \n');
    fprintf(fkml_id,'    </LineString> \n');
    fprintf(fkml_id,'  </Placemark> \n');
    
end



%%
fprintf(fkml_id,'</Document> \n');
fprintf(fkml_id,'</kml> \n');