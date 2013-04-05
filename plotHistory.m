clear

ini.fkml = 'G:\Projects\OI Trial\maze.kml';
[floor] = LoadMapKML(ini.fkml);
fig = 'figure(1)';
eval(fig)
plotParticles(fig,floor{1});

baseDir = pwd;
ctrlFile = importdata('G:\Projects\OI Trial\ctrlFile.txt');

for i = 1:size(ctrlFile,1)
   
    participant = [['P'] [num2str(ctrlFile(i,1))]];
    trialNo = [ ['00'] [num2str(ctrlFile(i,2))] ];
    if length(trialNo) == 4
        trialNo(1) = [];
    end

    a = [['cd '] [''''] ['G:\data\OITrial_Jan2013\Participants'] ['\'] [participant] ['\'] [trialNo] ['\'] ['''']];
    eval(a)
    
    %%
    fprintf('%s %s \n',participant,trialNo )
    ParticleHistory = importdata('ParticleHistory.txt');
    figure(1)
    hold on
    plot(ParticleHistory(:,4),ParticleHistory(:,2),'r')
    
    %%
    a = [['cd '] [''''] [baseDir] ['\'] ['''']];
    eval(a);

end


