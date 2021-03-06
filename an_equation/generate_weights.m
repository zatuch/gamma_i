function [wt1,wt2,wt3,wt4] = generate_weights(g,ocean,longs,lats)


[nz,ny,nx] = size(g);

wt1 = nan*ones(size(ocean)); wt2 = wt1; wt3 = wt1; wt4 = wt1;

inds_g = find(finite(g(1,:))); wt1(inds_g) = 0; wt2(inds_g) = 0; wt3(inds_g) = 0; wt4(inds_g) = 0;


lat1_lo = 36-4; lat1_hi = 36+4; dlat1 = lat1_hi-lat1_lo;

lat2_lo = 0-4; lat2_hi = 0+4; dlat2 = lat2_hi-lat2_lo;

long1_lo = 347-4; long1_hi = 347+4; dlong1 = long1_hi-long1_lo;

for j = 1:ny
for i = 1:nx
        
	if finite(g(1,j,i))
          
        if ocean(j,i)==5
            
            if lats(j,i)>=lat1_hi
                wt1(j,i) = 1;
            elseif lat2_hi<=lats(j,i) & lats(j,i)<=lat1_lo
                wt2(j,i) = 1;
            elseif lat1_lo<= lats(j,i) & lats(j,i)<=lat1_hi
                wt1(j,i) = (lats(j,i)-lat1_lo)/dlat1;  wt2(j,i) = 1-wt1(j,i);
            elseif lat2_lo<= lats(j,i) & lats(j,i)<=lat2_hi
                wt2(j,i) = (lats(j,i)-lat2_lo)/dlat2;  
                if 290<longs(j,i) & longs(j,i)<=long1_lo
                    wt3(j,i) = 1-wt2(j,i);
                elseif long1_hi<longs(j,i)|longs(j,i)<=15
                    wt4(j,i) = 1-wt2(j,i);
                end
            end 
            
        elseif ocean(j,i)==6
            
            if lats(j,i)<=lat2_lo
                
                if 290<longs(j,i) & longs(j,i)<=long1_lo 
                    wt3(j,i) = 1;
                elseif longs(j,i)>=long1_hi | longs(j,i)<=150 
                    wt4(j,i) = 1;
                elseif longs(j,i)>=long1_lo | longs(j,i)<=long1_hi 
                    wt4(j,i) = (longs(j,i)-long1_lo)/dlong1;  wt3(j,i) = 1-wt4(j,i);
                end
                
            elseif lat2_lo<= lats(j,i) & lats(j,i)<=lat2_hi
%                 wt2(j,i) = (lats(j,i)-lat2_lo)/dlat2;  wt3(j,i) = 1-wt2(j,i);                
                if 290<longs(j,i) & longs(j,i)<=long1_lo 
                    wt2(j,i) = (lats(j,i)-lat2_lo)/dlat2;  wt3(j,i) = 1-wt2(j,i);
                elseif longs(j,i)>=long1_hi | longs(j,i)<=150 
                    wt2(j,i) = (lats(j,i)-lat2_lo)/dlat2;  wt4(j,i) = 1-wt2(j,i);
                end

            end
            
        elseif ocean(j,i)==3 | ocean(j,i)==4
            
            if longs(j,i)>=long1_hi | longs(j,i)<=86 
                    wt4(j,i) = 1;
            end
            
        end
        
        if long1_lo<longs(j,i) & longs(j,i)<long1_hi & lat2_lo<lats(j,i) & lats(j,i)<lat2_hi
            
            r = (longs(j,i)-long1_lo)/dlong1; s = (lats(j,i)-lat2_lo)/dlat2;
            
            wt2(j,i) = s; wt3(j,i) = (1-r)*(1-s); wt4(j,i) = r*(1-s);
            
        end
        
    end
            
end
end

longss = nanmean(longs); latss = nanmean(lats');

figure(1)
    subplot(2,2,1), dj_pltmp(longss,latss,wt1), title('wt1')
    subplot(2,2,2), dj_pltmp(longss,latss,wt2), title('wt2')
    subplot(2,2,3), dj_pltmp(longss,latss,wt3), title('wt3')
    subplot(2,2,4), dj_pltmp(longss,latss,wt4), title('wt4')
    
figure(2), dj_pltmp(longss,latss,wt1+wt2+wt3+wt4), figure(1)

zoom on


save wts1234 wt1 wt2 wt3 wt4

           
return