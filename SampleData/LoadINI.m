global ini

%%

ini.fkml = [[pwd] '\AFloorNGB.kml'];

%ini.fkml = 'G:\Projects\OI Trial\maze.kml';
% ini.fkml = 'G:\data\Maps\AFloorNGB.kml';
% ini.fkml = 'G:\data\Maps\edin_bool_walkable.kml';

%%

% ini.fins = 'G:\data\JJ_001\Proc\POINT\ins.txt';
% ini.fins = 'G:\data\Tab_004\Proc\ins.txt';
% ini.fins = 'G:\data\EdinDump\Walk2-HolyroodtoGeog\IMU\ins.txt';
% ini.fins = 'G:\data\EdinDump\Walk2-HolyroodtoGeog\IMU\Artisan Crafted Result\ins.txt';
ini.fins = [[pwd] '\ins.txt'];

%%

% ini.fzupt = 'G:\data\JJ_001\Proc\zupt.txt';
% ini.fzupt = 'G:\data\Tab_004\Proc\zupt.txt';
% ini.fzupt = 'G:\data\EdinDump\Walk2-HolyroodtoGeog\IMU\ins.txt';


%%

% ini.fgnss = 'G:\data\EdinDump\Walk2-HolyroodtoGeog\uBlox\bob2.nmea';
% ini.fgnss = [[pwd] '\gnss.nmea'];
ini.GNSStoIMUtime = -20;
%%

ini.HistoryOP = [[pwd] '\ParticleHistory.txt'];

%%

ini.forward = true;
ini.filterUpdateDist = 0.5;

%ini.origin.lat = [55.9512590000000;];
%ini.origin.lon = [-3.16934400000000;];

ini.origin.lat = [52.9517424553974;];
ini.origin.lon = [-1.18413620109170;];

ini.n_particles =1000;

% ini.north = 9.8;
% ini.east = 11;
ini.north = 2;
ini.east = 14;
ini.TwoDstd = 1;

% ini.Heading = 90;
 ini.Heading = 90;
ini.HeadingStd = 15;

ini.DistanceStd = 0.2;
ini.DeltaHeadingStd = 1.5;
ini.HeadingDrift = 0.;

ini.UseCardinal = false;
ini.Cardinal = 0;
ini.Cardinalconfidence = 0;