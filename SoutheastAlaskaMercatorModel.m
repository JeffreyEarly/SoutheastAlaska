classdef SoutheastAlaskaMercatorModel < KinematicModel

    
    properties
        path_velocityfield = 'Data/MERCATOR_2017_surface.mat';
        path_coastline = 'Data/SoutheastAlaskaProjected.mat';
        
        x0 = 403000;
        y0 = 6454000;
        zone = 8;
        
        uInterpolant
        vInterpolant
    end
    
    methods
        function self = SoutheastAlaskaMercatorModel()
            self.LoadCoastlinesFromPath(self.path_coastline);
            self.LoadVelocityFieldFromPath(self.path_velocityfield);
                        
            self.name = 'Southeast Alaska Mercator Model';
        end
        
        function self = LoadCoastlinesFromPath(self,path)
            load(path,'SEAKProjectedPolygons');
            [xlim,ylim] = boundingbox(SEAKProjectedPolygons(1));
            for i=2:length(SEAKProjectedPolygons)
                [xlim2,ylim2] = boundingbox(SEAKProjectedPolygons(i));
                if xlim2(1) < xlim(1)
                    xlim(1) = xlim2(1);
                end
                if xlim2(2) > xlim(2)
                    xlim(2) = xlim2(2);
                end
                if ylim2(1) < ylim(1)
                    ylim(1) = ylim2(1);
                end
                if ylim2(2) > ylim(2)
                    ylim(2) = ylim2(2);
                end
            end
                        
            self.obstacles = SEAKProjectedPolygons;
            self.xVisLim = xlim;
            self.yVisLim = ylim;
        end
        
        function self = LoadVelocityFieldFromPath(self,path)
            S = load(path);
            nDays = size(S.u,1);
            
            % Append the first day, after the last, to make interpolation
            % simpler.
            u = cat(1,S.u,S.u(1,:,:));
            v = cat(1,S.v,S.v(1,:,:));
            
            t = 0:nDays;
            [T,LAT,LON] = ndgrid(t,S.lat,S.lon);
            self.uInterpolant = griddedInterpolant(T,LAT,LON,u);
            self.vInterpolant = griddedInterpolant(T,LAT,LON,v);
        end
        
        function u = u(self,t,x,y)
            tVec = mod(t/86400,365)*ones(size(x));
            [lat,lon] = UTMToLatitudeLongitude( x+self.x0,y+self.y0,self.zone );
            u = self.uInterpolant(tVec,lat,lon);
            u(isnan(u)) = 0;
        end
        
        function v = v(self,t,x,y)
            tVec = mod(t/86400,365)*ones(size(x));
            [lat,lon] = UTMToLatitudeLongitude( x+self.x0,y+self.y0,self.zone );
            v = self.vInterpolant(tVec,lat,lon);
            v(isnan(v)) = 0;
        end
    end
end