function F = root2d(x,dt,Fi,Fj)
g = 9.81;  
%kind of works F(1) = x(1)*log(-(Fi-Fj)/(dt*x(2))) - log(Fi/(dt*x(2)));
%F(1) = x(1)*log(-g*dt/x(2)) - log(-(Fi-Fj)/(x(2)));
%kind of works F(2) = x(2)^2/(g*(x(1)+1))*(g*dt/-x(2))^(x(1)+1)+Fi*dt;
%F(2) = x(2)^2/(g*(x(1)+1))*(g*dt/-x(2))^(x(1)+1)-(Fi-Fj)*dt;
F(1) = log(Fj/x(2))*log(g*dt/x(2)) - log(Fi/x(2))*log(g*5e-6/x(2));
F(2) = x(2)^2/(g*(x(1)+1))*(g*dt/x(2))^(x(1)+1)-Fi*dt;
%F(2) = x(2)^2/(g*(x(1)+1))*(g*dt/x(2))^(x(1)+1)-Ii;