%--------------------------------------------------------------------------
% Wind interpolation (magnitude & angle)
%-------------------------------------------------------------------------- 
Tref = zeros(nnodes,1);
if strcmpi(type,'triple')
    nodes = ELEMnodes(Jelem,:);
end
for j = 1:nnodes
    if strcmpi(type,'single')
        j = Jnode;
    elseif strcmpi(type,'triple')
        if j == 1
            j = nodes(1);
        elseif j == 2
            j = nodes(2);
        else
            j = nodes(3);
        end
    end
    if strcmpi(wind_type,'dgwave') && strcmpi(data_type,'initial') 
        n  = 0;
        U  = sqrt(Uw(j,:).^2 + Vw(j,:).^2); % check = 0; shift = 0; kk = 0;
        for k = 1:Lw
            if abs(Uw(j,k)) < 5e-6 && abs(Vw(j,k)) < 5e-6
                theta_w(k,1) = 0;
            elseif abs(Uw(j,k)) < 5e-6
                theta_w(k,1) = pi/2;
            else
                theta_w(k,1) = atan(abs(Vw(j,k))/abs(Uw(j,k)));
            end
            if Uw(j,k) > 0 && Vw(j,k) > 0      % 1st quadrant
                quadrant(k,j) = 1;
            elseif Uw(j,k) < 0 && Vw(j,k) > 0  % 2nd quadrant
                quadrant(k,j) = 2;
            elseif Uw(j,k) < 0 && Vw(j,k) < 0  % 3rd quadrant
                quadrant(k,j) = 3;
            elseif Uw(j,k) > 0 && Vw(j,k) < 0  % 4th quadrant
                quadrant(k,j) = 4;
            end
            if Uw(j,k) == 0 && Vw(j,k) > 0      % 1st quadrant
                quadrant(k,j) = -1;
            elseif Uw(j,k) < 0 && Vw(j,k) == 0  % 2nd quadrant
                quadrant(k,j) = -2;
            elseif Uw(j,k) == 0 && Vw(j,k) < 0  % 3rd quadrant
                quadrant(k,j) = -3;
            elseif Uw(j,k) > 0 && Vw(j,k) == 0  % 4th quadrant
                quadrant(k,j) = -4;
            end
        end
        Uavg = U;
    elseif strcmpi(wind_type,'ndbc') && strcmpi(data_type,'initial')
        n  = 0;
        for k = 1:Lw
            if theta_w(k) > 0 && theta_w(k) < 90          % 1st quadrant
                quadrant(k,j) = 1;
            elseif theta_w(k) > 90  && theta_w(k) < 180   % 2nd quadrant
                quadrant(k,j) = 2;
                theta_w(k)    = theta_w(k) - 90;
            elseif theta_w(k) > 180 && theta_w(k) < 270   % 3rd quadrant
                quadrant(k,j) = 3;
                theta_w(k)    = theta_w(k) - 180;
            elseif theta_w(k) > 270 && theta_w(k) < 360   % 4th quadrant
                quadrant(k,j) = 4;
                theta_w(k)    = theta_w(k) - 270;
            end
            if theta_w(k) == 90       % 1st quadrant
                quadrant(k,j) = -1;
            elseif theta_w(k) == 180   % 2nd quadrant
                quadrant(k,j) = -2;
                theta_w(k)    = 0;
            elseif theta_w(k) == 270  % 3rd quadrant
                quadrant(k,j) = -3;
                theta_w(k)    = 90;
            elseif theta_w(k) == 360  % 4th quadrant
                quadrant(k,j) = -4;
                theta_w(k)    = 0;
            end
            theta_w(k) = degtorad(theta_w(k));
        end
    %elseif strcmpi(wind_type,'dgwave') && strcmpi(data_type,'cascade')
    elseif strcmpi(data_type,'cascade')
        U = U_nodes(:,j);
        theta_w = T_nodes(:,j);
        if n == 1
            quadrant(:,j) = Q_nodes(1:(end-(2+n)),j);
        else
            quadrant(:,j) = Q_nodes(1:(end-1),j);
        end
    end
    i = 1:Lw-(2+n); difT = abs(theta_w(i+1)-theta_w(i));
    %Tref = max(difT)/(2*dt);
    Tref(j) = (sum(difT)/Lw)/(2*dt); Tref(j) = Tref(j)*.1; %Tref(j) = Tref(j)*.01;
    %--------------------------------------------------------------------------
    % Wind interpolation (Uo & q)
    %--------------------------------------------------------------------------
    options = optimoptions('fsolve');
    options = optimoptions(options,'Display','off'); % turn off fsolve output.
    for k = 1:Lw-(1+n)
        Ul = U(k) + 1;    Ur = U(k+1) + 1;
        if Ul < 1e-7
            Ul = 5e-6;
        end
        if Ur < 1e-7
            Ur = 5e-6;
        end
        if strcmpi(nl_solver,'Newton')
            x0 = [0.1,.5*(Ul+Ur)]';
            [q(k,j),Uo(k,j)] = characteristic_constant(x0,Ul,Ur,g,dt,5e-6,j);
        else
            x0 = [0.1,.5*(Ul+Ur)];
            x  = fsolve(@(x) root2d(x,dt,Ur,Ul),x0,options);
            q(k,j)  = x(1);
            Uo(k,j) = x(2);
        end
        %-------------------
        %Direction (Uo & r)
        %-------------------
        if strcmpi(nl_solver,'Newton')
            Tl  = theta_w(k,1) + 1.0;  Tr  = theta_w(k+1,1) + 1.0;
        else
            Tl = real(theta_w(k,1));   Tr  = real(theta_w(k+1,1));
        end
        if Tl < 1e-7
            %Tl = 5e-7;
            Tl = 5e-6;
        end
        if Tr < 1e-7
            %Tr = 5e-7;
            Tr = 5e-6;
        end
        if Tl == Tr
            r(k,j)  = 0;
            To(k,j) = Tl;
        else
            %Tavg = 1/2*(Tr+Tl)+ 10/20*(Tr-Tl);
            Tavg = Tr;
            %x0 = [0.01,.5*(Tl+Tr)];
            if strcmpi(nl_solver,'Newton')
                x0 = [0.1,.5*(Tl+Tr)]';
                [r(k,j),To(k,j)] = characteristic_constant(x0,Tl,Tr,Tref(j),dt,5e-6,j);
            else
                x0 = [0.1, .5*(Tl+Tr)];
                x  = fsolve(@(x) root2d_theta(x,dt,Tr,Tl,Tref(j),Tavg),x0,options);
                r(k,j)  = x(1);
                To(k,j) = x(2);
            end
            if Tr > Tl && r(k,j) < 0
                r(k,j) = -r(k,j);
            elseif Tr < Tl && r(k,j) > 0
                r(k,j) = -r(k,j);
            end
        end
    end
    if strcmpi(type,'single')
        break
    elseif strcmpi(type,'triple')
        if j == 3
            break
        end
    end
end