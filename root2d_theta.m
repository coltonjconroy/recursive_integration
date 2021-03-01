function F = root2d_theta(x,dt,Fi,Fj,ref,Favg)
 F(1) = log(Fj/x(2))*log(ref*dt/x(2)) - log(Fi/x(2))*log(ref*5.0e-6/x(2));
 F(2) = x(2)^2/(ref*(x(1)+1))*(ref*dt/x(2))^(x(1)+1)-Favg*dt;
% % F(1) = log(Fj/x(2))*log(x(3)*dt/x(2)) - log(Fi/x(2))*log(x(3)*5e-6/x(2));
% % F(2) = x(2)^2/(x(3)*(x(1)+1))*(x(3)*dt/x(2))^(x(1)+1)-Fj*dt-(1/2)*dt*(x(3)*x(1)*(x(3)/x(2)*dt)^(x(1)-1));
% % F(3) = x(3)*x(1)*(x(3)/x(2)*dt)^(x(1)-1) - wt;
%F(1) = log(Fj/x(2))*log(ref*dt/x(2)) - log(Fi/x(2))*log(ref*5e-6/x(2));
%F(2) = ref*x(1)*(ref/x(2)*dt)^(x(1)-1)*dt - wt*dt;