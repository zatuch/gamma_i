function wt = weight_horizontal(p0,g0,dgamma,const, ...
                                s1_lo,ct1_lo,p1_lo,s1_hi,ct1_hi,p1_hi)
                            
%          dsig = dsigl(s(k_east(k0,j0,i0),j0,i0_east),ct(k_east(k0,j0,i0),j0,i0_east),p(k_east(k0,j0,i0),j0,i0_east), ...
%                                 s(k_east(k0,j0,i0)+1,j0,i0_east),ct(k_east(k0,j0,i0)+1,j0,i0_east),p(k_east(k0,j0,i0)+1,j0,i0_east));
                             
%          wt = 1.5e-7/((10^-N2_wt_exp)^2+dsig*dsig); wt_lmax = max(wt_lmax,wt); %wt = 1/wt;
          
%          wt = wt*(1+p(k0,j0,i0)/1000)^pressure_wt_exp;
          
%          if finite(logD(k0,j0,i0)), wt = wt*(1+logD_wt/abs(logD(k0,j0,i0))); end

%wt = exp(-helicity/hmedian)^1; wt = 100;

if const~=0
    dp = p1_hi - p1_lo;
    wt = dp/(const+abs(dgamma));
else
    wt = 1;
end

%wt = 1;
          
 %         if ~finite(wt)
 %             wt = 1;
 %             error('east weight not finite')
 %         end
          
%if isnan(wt)
%    wt = 0.3;
%    not_ok = 'a nan weight!!!'
%end
          
%wt = wt*(1+g0/1000)^pressure_wt_exp; 

%wt = wt*(g0/28.5)^0;
          
%          if abs(g0-27.25)<=0.1, wt = 10*wt; end
          
%          wmax = max([wmax; wt]);
            
%          if j0~=(ny+1)/2 | i0~=(nx+1)/2, wt = 10^3; end


return
          