% load('world_vector_shoreline_SEAK.mat');

% coasts = shaperead('ne_10m_coastline/ne_10m_coastline.shp');
% save('coastlines.mat','coasts');

%% bounding boxes are given in lower-left, upper-right format
load('Data/coastlines.mat');

coastPolyshapes = cell(length(coasts),1);
for i=1:length(coasts)
    if i== 250
        coasts(i).X = [flip(coasts(i).X), max(coasts(i).X)+1, max(coasts(i).X)+1, min(coasts(i).X)];
        coasts(i).Y = [flip(coasts(i).Y), min(coasts(i).Y), max(coasts(i).Y)+1, max(coasts(i).Y)+1];
    end
    coastPolyshapes{i} = polyshape(coasts(i).X,coasts(i).Y);
end

xmin = -137.5; xmax = -133.0;
ymin = 56; ymax = 59.5;

boundaryOfInterest = polyshape([xmin xmin xmax xmax],[ymax ymin ymin ymax]);

SEAKPolys = {}; iSEAK = 0;
for i=1:length(coastPolyshapes)
    if overlaps( coastPolyshapes{i}, boundaryOfInterest)
        iSEAK = iSEAK + 1;
        SEAKPolys{iSEAK} = intersect( coastPolyshapes{i}, boundaryOfInterest );
    end
end

% we have to pick a single zone
zone = floor(-135 / 6.0) + 31;
x0 = 403000;
y0 = 6454000;
SEAKProjectedPolys = cell(size(SEAKPolys));
for i=1:length(SEAKPolys)
    [x,y] = LatitudeLongitudeToUTMZone( SEAKPolys{i}.Vertices(:,2), SEAKPolys{i}.Vertices(:,1), zone );
    SEAKProjectedPolys{i} = polyshape(x-x0,y-y0);
end

SEAKProjectedPolygons = SEAKProjectedPolys{1};
for i=2:length(SEAKProjectedPolys)
    SEAKProjectedPolygons = cat(1,SEAKProjectedPolygons,SEAKProjectedPolys{i});
end

figure
for i=1:length(SEAKProjectedPolygons)
    plot( SEAKProjectedPolygons(i) ), hold on
end

save('SoutheastAlaskaProjected.mat','SEAKProjectedPolygons');