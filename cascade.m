%**************************************************************************
%
%                turbulence cascades - wind averaging
%                     Written by Colton J. Conroy
%                               @ APAM
%                               7/01/16
%
%**************************************************************************
%ld = 5e-6;  % inner cut-off
ld = ld_i(n);
dtn = dt/2; L = 1/dtn; % averaging window
U_nodes = zeros(length(Uo(:,1))*2,nnodes);
T_nodes = zeros(length(To(:,1))*2,nnodes);
Q_nodes = zeros(length(quadrant(:,1))*2,nnodes);
for i = 1:nnodes
    if strcmpi(type,'single')
        i = Jnode;
    elseif strcmpi(type,'triple')
        if i == 1
            i = nodes(1);
        elseif i == 2
            i = nodes(2);
        else
            i = nodes(3);
        end
    end
    Uold = Uo(:,i); Told = To(:,i);
    Q = q(:,i);     R = r(:,i);
    Unew = zeros(length(Uold)*2,1);
    Tnew = zeros(length(Told)*2,1);
    Qnew = zeros(length(quadrant(:,i))*2,1); % new quadrants
    k = 0;
    for j = 1:Lw-1
        k = k + 1;
        Unew(k)   = L*(Uold(j)^2/(g*(Q(j)+1)) * (g*dtn/Uold(j))^(Q(j)+1) ...
            -    Uold(j)^2/(g*(Q(j)+1)) * (g*ld/Uold(j))^(Q(j)+1));
        Tnew(k)   = L*(Told(j)^2/(Tref(i)*(R(j)+1)) * (Tref(i)*dtn/Told(j))^(R(j)+1) ...
            -    Told(j)^2/(Tref(i)*(R(j)+1)) * (Tref(i)*ld/Told(j))^(R(j)+1));
        Qnew(k)   = quadrant(j,i);
        %if Tnew(k) > pi/2
        %    Tnew(k) = pi/2;
        %end
        k = k + 1;
        Unew(k) = L*(Uold(j)^2/(g*(Q(j)+1)) * (g*dt/Uold(j))^(Q(j)+1) ...
            -    Uold(j)^2/(g*(Q(j)+1)) * (g*dtn/Uold(j))^(Q(j)+1));
        Tnew(k) = L*(Told(j)^2/(Tref(i)*(R(j)+1)) * (Tref(i)*dt/Told(j))^(R(j)+1) ...
            -    Told(j)^2/(Tref(i)*(R(j)+1)) * (Tref(i)*dtn/Told(j))^(R(j)+1));
        Qnew(k) = quadrant(j,i);
        % if Tnew(k) > pi/2
        %     Tnew(k) = pi/2;
        % end
        %------------
        % dissipation
        %------------
        Udiss(k,i,n)     = Uavg(j+1) - 1/2*(Unew(k) + Unew(k-1) - 2);
        Udiss(k-1,i,n)   = Udiss(k,i,n);
        Uparent(k,i,n)   = j+1;
        Uparent(k-1,i,n) = j+1;
    end
    %-----------------
    % update variables
    %-----------------
    clear theta_w  U Uavg
    Uavg    = Unew; 
    %    Qold    = Q;
    %    Rold    = R;
    %    U       = Unew;
    theta_w = real(Tnew);
    is_nan  = isnan(theta_w);
    nanj    = find(is_nan == 1);
    check   = isempty(nanj);
    if check == 0
        theta_w(nanj) = theta_w(nanj(1)-1);
    end
    U_nodes(:,i) = Unew;
    T_nodes(:,i) = theta_w;
    Q_nodes(:,i) = Qnew;
    if strcmpi(type,'single')
        break
    elseif strcmpi(type,'triple')
        if i == 3
            break
        end
    end
end
Lw      = length(Unew);
N       = Lw;
data_dt = data_dt/2;
dt      = 60*data_dt;
dt_n(n) = dt;
T       = N*data_dt*60;
NTw     = floor(dt/deltat);
NT      = floor(T/deltat)-1;
    
    