clear;%cd ~/Dropbox/Nakita-Harper-Thilo/SCRIPTS/ 
bb=[-137.2500 -132.5000+3   53.5   58.7500]
load Data/world_vector_shoreline_SEAK.mat % an extraction from a shoreline database 
load Data/topo30_SEAK.mat                 % a global topography database 
load Data/MERCATOR_2017_surface.mat       % MERCATOR model
whos
%% plot the topography
% figure(1);clf;colormap(lansey(14));pcolor(ss.lon,ss.lat,ss.z);shading flat;axis xy;
% daspect([1 cosd(57) 1]);
%   set(gca,'xlim',[bb(1) bb(2)],'ylim',[bb(3) bb(4)]);caxis([-750,0]);colorbar
%  hold on;plot(wvs.lon,wvs.lat,'k')
%%
size(u) % the data is dimensioned 365 x 77 x 101
        %                         year-day x lat x lon
%% let's plot October mean velocity
% tdx = date2doy(datenum(2017,10,1)):date2doy(datenum(2017,10,31)) % get October time indices which equals day of year

clear tmp*
tmpu = squeeze((u(1,:,:)));
tmpv = squeeze((v(1,:,:)));
figure(2);clf
scale_factor = 1;
quiver(lon,lat,scale_factor*tmpu,scale_factor*tmpv,0,'k');hold on
plot(wvs.lon,wvs.lat,'b','linew',2)
  set(gca,'xlim',[bb(1) bb(2)],'ylim',[bb(3) bb(4)]);
  ylabel('latitude')
  xlabel('longitude')
  title('October 2017 mean surface currents')
%%
