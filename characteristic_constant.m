function [u,q] = characteristic_constant(x,Fj,Fi,g,dt,ld,j)
%ld = 5e-6;
tol = 1e-6;
df = 1; i = 0;

while max(df) > tol
    
    [F,f] = jacobian(x,Fj,Fi,g,dt,ld);    
    i = i + 1;
    %xn = x - f\F;
    xn = x - f*F;
    df = abs(xn-x);
    x  = xn;
    
    if i > 20
        display('iterations in nonlinear CC solver exceeded break tolerance')  
        j
        df
        break
    end
    
end

u = x(1);
q = x(2);

function [F,f] = jacobian(x,Fj,Fi,g,dt,ld)

F = zeros(2,1); f = zeros(2,2);  % f is the inverse

F(1) = log(Fj/x(2))*log(g*dt/x(2)) - log(Fi/x(2))*log(g*ld/x(2));
F(2) = x(2)^2/(g*(x(1)+1))*(g*dt/x(2))^(x(1)+1)-Fi*dt;  

% f(1,1) = 0; 
% f(1,2) = log(Fi/x(2))/x(2) - log(Fj/x(2))/x(2) - log((dt*g)/x(2))/x(2) ...
%        + log((g*ld)/x(2))/x(2);
% f(2,1) = (dt*x(2)*((dt*g)/x(2))^x(1)*(log((dt*g)/x(2)) + ...
%           x(1)*log((dt*g)/x(2)) - 1))/(x(1) + 1)^2;
% f(2,2) = -(dt*(x(1) - 1)*((dt*g)/x(2))^x(1))/(x(1) + 1);
        
f(1,1) = -((x(1) - 1)*(x(1) + 1))/((log((dt*g)/x(2)) + x(1)*log((dt*g)/x(2)) ...
         - 1)*(log((dt*g)/x(2)) - log((g*ld)/x(2)) - log(Fi/x(2)) + log(Fj/x(2))));
     
f(1,2) = (x(1) + 1)^2/(dt*x(2)*((dt*g)/x(2))^(x(1))*(log((dt*g)/x(2)) + ...
          x(1)*log((dt*g)/x(2)) - 1));
      
f(2,1) = -x(2)/(log((dt*g)/x(2)) - log((g*ld)/x(2)) - log(Fi/x(2)) + log(Fj/x(2)));

f(2,2) = 0; 
      
