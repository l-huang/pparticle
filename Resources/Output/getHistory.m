function [posn] = getHistory(ini,observation)

global ParticleHistories

fid = fopen(ini.HistoryOP,'w');

posn = zeros(size(ParticleHistories,2),5);

for i = 1:length(observation)
    posn(i,1) = observation(i).INStime;
end

for epoch = 1:size(ParticleHistories,2)
    
    epochData = ParticleHistories(:,epoch);
    
    x = 1./zeros(size(ParticleHistories,1),1);
    y = 1./zeros(size(ParticleHistories,1),1);
    
    for i = 1:length(epochData)
        
        if ~isempty(epochData(i).x)
            x(i) = epochData(i).x; 
        end
        if ~isempty(epochData(i).y)
            y(i) = epochData(i).y;
        end
        
    end
    
    posn(epoch,2) = mean(x);
    posn(epoch,3) = std(x);
    posn(epoch,4) = mean(y);
    posn(epoch,5) = std(y);
    
end


for i = 1:size(posn,1)
   
    fprintf(fid,'%f \t %f \t %f \t %f \t %f \n',posn(i,:));
   
end

