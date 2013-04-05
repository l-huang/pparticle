global ini

%%

ini.fkml = 'G:\Projects\OI Trial\maze.kml';

%%

% ini.fins = [[pwd] '\ins.txt'];

%%

ini.GNSStoIMUtime = -20;

%%

% ini.HistoryOP = [[pwd] '\ParticleHistory.txt'];

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

ini.north = 28.7;
ini.east = 52.7;
ini.TwoDstd = 0.1;

% ini.Heading = 90;
ini.Heading = -90;
ini.HeadingStd = 360;

ini.DistanceStd = 0.2;
ini.DeltaHeadingStd = 1.5;
ini.HeadingDrift = 0.;

ini.UseCardinal = false;
ini.Cardinal = 0;
ini.Cardinalconfidence = 0;