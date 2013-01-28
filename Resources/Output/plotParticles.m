function [] = plotParticles(fig,floor)

eval(fig)
hold off
if isfield(floor,'doors')
    plot(floor.doors(:,1),floor.doors(:,2),'ob')
end
hold on
for i = 1:size(floor.polys,2)
    poly = floor.polys{i}.coords;
    hold on
    for j = 2:size(poly,1)
        plot([poly(j,1) poly(j-1,1)],[poly(j,2) poly(j-1,2)],'k')
    end
end

% plot(particles(:,1),particles(:,2),'ob')