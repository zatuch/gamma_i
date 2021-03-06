function [h,h_east,h_north,h_west,h_south] = helicities_4(s,t,ct,p,ocean,n,longs,lats,bc)

%%%
%%%   helicities  -  4 helicities on dx or dy grid from s-ct loops
%%%
%%%   Usage:         [h_east,h_north,h_west,h_south] = helicities(s,t,ct,p,ocean,n,longs,lats,bc)
%%%
%%%   Input:         s       - salinity (PSU)                           {nz,ny,nx}
%%%                  t       - in situ temperature (ITS90)              {nz,ny,nx}
%%%                  ct      - conservative temperature (ITS90)         {nz,ny,nx}
%%%                  p       - pressure (db)                            {nz,ny,nx} 
%%%                  longs   - longitude (degE)                         {ny,nx}
%%%                  lats    - latitude (degN)                          {ny,nx}
%%% 
%%%   Output:        [h_east,h_north,h_west,h_south]
%%%
%%%                          - helicities                               {nz,ny,nx}
%%%
%%%   Method:        s-ct loop estimates, (formula 3)
%%%  
%%%   Author:        David Jackett
%%%
%%%   Date:          13/07/06
%%%


                                                 %    interior helicity
[nz,ny,nx] = size(s); nz2 = round(nz/2);

if bc==1
    s(:,:,nx+1) = s(:,:,1); ct(:,:,nx+1) = ct(:,:,1);
else
    s(:,:,nx+1) = nan;       ct(:,:,nx+1) = nan;
end

integral_s_dct = 0.5*(s(:,1:ny-1,1:nx)+s(:,1:ny-1,2:nx+1)).*(ct(:,1:ny-1,2:nx+1)-ct(:,1:ny-1,1:nx));

integral_s_dct = integral_s_dct + 0.5*(s(:,1:ny-1,2:nx+1)+s(:,2:ny,2:nx+1)).*(ct(:,2:ny,2:nx+1)-ct(:,1:ny-1,2:nx+1));

integral_s_dct = integral_s_dct + 0.5*(s(:,2:ny,2:nx+1)+s(:,2:ny,1:nx)).*(ct(:,2:ny,1:nx)-ct(:,2:ny,2:nx+1));

integral_s_dct = integral_s_dct + 0.5*(s(:,2:ny,1:nx)+s(:,1:ny-1,1:nx)).*(ct(:,1:ny-1,1:nx)-ct(:,2:ny,1:nx));

h = integral_s_dct; s = s(:,:,1:nx); ct = ct(:,:,1:nx);


%       normalize on depth levels

longss = longs(1,:)'; latss = lats(:,1);

for kk = 1:nz
    hh = squeeze(h(kk,:,:));
    
    figure(7), subplot(2,1,1), hist(hh,100), grid on
        
    hh_mean = nanmean(hh(:)), hh_std = nanstd((hh(:))), nstd = 3;
    
    hh = change(hh,'<=',hh_mean-nstd*hh_std,hh_mean-nstd*hh_std);
    
    hh = change(hh,'>=',hh_mean+nstd*hh_std,hh_mean+nstd*hh_std); 
    
    h(kk,:,:) = hh; hh = squeeze(h(kk,:,:));
    
    subplot(2,1,2), hist(hh,100), grid on, dj_pause(2)
      
end


                                                 %    easterly helicity
                                                 
h_east = nan*ones(size(s)); h_east(:,1,:) = h(:,1,:);

for i = 1:nx
  for j = 2:ny-1
    for k = 1:nz
        if finite(h(k,j,i))
            h_east(k,j,i) = h(k,j,i);
            if abs(h(k,j-1,i))<abs(h(k,j,i))
                h_east(k,j,i) = h(k,j-1,i);
            end
        elseif finite(h(k,j-1,i))
            h_east(k,j,i) = h(k,j-1,i);
        end
    end
  end
end

h_east(:,ny,:) = h(:,ny-1,:);                                                 

                                                 %    westerly helicity
                                                 
z = h_east(:,:,nx); h_west(:,:,2:nx) = h_east(:,:,1:nx-1); h_west(:,:,1) = z;
                                                 

                                                 %    northerly helicity
                                                                                           
h_north = nan*ones(size(s));
for i = 1:nx
  if i==1
    if bc==1
      ilo = nx;                                                               %%  possible errors ???
    else
      ilo = 1;
    end
  else
    ilo = i-1;
  end
  for j = 1:ny-1
    for k = 1:nz
        if finite(h(k,j,i))
            h_north(k,j,i) = h(k,j,i);
            if abs(h(k,j,ilo))<abs(h(k,j,i))
                h_north(k,j,i) = h(k,j,ilo);
            end
        elseif finite(h(k,j,ilo))
            h_north(k,j,i) = h(k,j,ilo);
        end
    end
  end
end

                                          
                                                 %    southerly helicity
                                                 
h_south = nan*ones(size(s)); h_south(:,2:ny,:) = h_north(:,1:ny-1,:);
                                                 



                                                 %    plot east

helicity_max = nanmax(abs(h_east(:)))

z = squeeze(h_east(nz2,:,:));

longss = longs(1,:)'; latss = lats(:,1); whos

dj_pltmp(longss,latss,z), figure
    hh = z(find(finite(z))); hist(hh,100)

                                                 %    plot west
                                                 
helicity_max = nanmax(abs(h_west(:)))

z = squeeze(h_west(nz2,:,:));

figure, dj_pltmp(longss,latss,z), figure
    hh = z(find(finite(z))); hist(hh,100)


                                                 %    plot north

helicity_max = nanmax(abs(h_north(:)))

z = squeeze(h_north(nz2,:,:));

figure, dj_pltmp(longss,latss,z), figure
    hh = z(find(finite(z))); hist(hh,100)


                                                 %    plot south

helicity_max = nanmax(abs(h_south(:)))

z = squeeze(h_south(nz2,:,:));

figure, dj_pltmp(longss,latss,z), figure
    hh = z(find(finite(z))); hist(hh,100)


                                                 %    plot inner helicity
                                                 
helicity_max = nanmax(abs(h(:)))

z = squeeze(h(nz2,:,:));

figure, dj_pltmp(longss,latss(1:ny-1),z)




return


