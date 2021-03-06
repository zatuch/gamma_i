function A = Agen21(s,t)

n = length(s); A = zeros(n,21);

A(:,1)  = ones(n,1);   
A(:,2)  = s;
A(:,3)  = t;
    
A(:,4)  = s.*s;                 %   s^2
A(:,5)  = s.*t;                 %   s   t
A(:,6)  = t.*t;                 %       t^2
    
A(:,7)  = s.*A(:,4);            %   s^3
A(:,8)  = s.*A(:,5);            %   s^2 t
A(:,9)  = s.*A(:,6);            %   s   t^2
A(:,10) = t.*A(:,6);            %       t^3
    
A(:,11) = s.*A(:,7);            %   s^4 
A(:,12) = s.*A(:,8);            %   s^3 t
A(:,13) = s.*A(:,9);            %   s^2 t^2
A(:,14) = s.*A(:,10);           %   s   t^3
A(:,15) = t.*A(:,10);           %       t^4
    
A(:,16) = s.*A(:,11);           %   s^5 
A(:,17) = s.*A(:,12);           %   s^4 t
A(:,18) = s.*A(:,13);           %   s^3 t^2
A(:,19) = s.*A(:,14);           %   s^2 t^3
A(:,20) = s.*A(:,15);           %   s   t^4
A(:,21) = t.*A(:,15);           %       t^5


return