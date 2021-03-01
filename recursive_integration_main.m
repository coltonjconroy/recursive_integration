%**************************************************************************
%
% Recursive Integration Method for temporal non-Gaussian wind interpolation
%                     Written by Colton J. Conroy
%         @ Applied Physics and Applied Mathematics Department
%              Columbia University in the City of New York
%                            12/2/16
%     
%**************************************************************************
clear; 
%--------------------
% figures
%--------------------
wind_fig      = 'off';
direction_fig = 'off';
dg_fig        = 'off';
mesh_fig      = 'off';
diss_fig      = 'off';
diss_fig_type = 'casc';
data_type     = 'initial';
wind_type     = 'ndbc'; month = '8'; year = '2011'; %2012_44065'; % Calendar year == Lake Erie
w_fig         = 'g_avg';                            % Calendar year_buoy# == Sandy
cascades      = 'on';             % recursions on?
ncascades     = 6;                % number of recursions (can be anywhere between 1-7)
cascade_type  = 'nonfilling';     % filling or nonfilling? (i.e., conservative or nonconservative)
nl_solver     = 'Newton';         % numerical solver for characterisitc constants.
type          = 'single';         % (single, triple, full, i.e., one spatial point, one triangular element, or an entire mesh)
qstat         = 'off';            % calculate statistics of q?
ic_file       = 'off';            % create initial condition files for fortran? 
Jnode         = 751;              % node to create space-time fractal
Jelem         = 1428;
ld_1          = 130;              % initial inner cut-off (currently set for 8/2011). Must adjust this value until structure function matches observations in Figure                          
                                  % for Sandy ld_1 = 73, use 4 cascades, p_offset changes;
p_offset = 0.76;                  % there's a temporal offset between calcs and observations
                                  % that will change for a given data set bc of the number of 
                                  % cascades used (a cascade removes time from the data set).               
%**************************************************************************                                  
% NOTE: If in the tau figure, the second zero (qcrit) does not equal 5, OR 
% if the structure functions do not match observations in the displayed 
% figure, then the user needs to change ld_1. If filling cascascades are 
% used then a value of approx. 0.20 must be subtracted from the signigicant 
% wave height calc bc the space filling approach does not dissipate energy.
% If the calculated significant wave height is too large as
% compared to observation data then try using more cascades to dissipate
% more energy. If using wind interpolation for spectral resolving model,
% use 4-7 cascades to generate full u10 and then average over a window that
% corresponds to the model time step. For instance, if time step is 1
% minute, create the fully casacaded wind data using 4-7 cascades and then
% use the function U10 below and then avearge this result over 1 minute windows. 
% Also, there is an offset between observations and calculations in the
% plot that must be taken into account. This offset must chage depending on
% the number of cascades and the month of observational data (the variable
% p_offset). Finally, in this program we use H = 1/De as an approximation,
% however, the correct way would be to calculate the graph dimension of the
% wind interpolation and then set H equal to H = 2 - Dg. The graph
% dimension of the wind can be calculated via the separate program 
% fractal_dimension.m and the graph dimension of the fluctuation velocity 
% can be calculated via fractal_dimension_vel.m
%**************************************************************************
%-------------------
% Input
%-------------------
Pa       = 101.325e3; % Atmsopheric pressure (Pa)
g        = 9.80665;   % Acceleration due to gravity
lambda   = 1.58e-4;   % Shape factor            
rho      = 1.27;      % Density of air
Mtol     = eps;
half     = 1/2;
[alpha,beta,crk] = RKssp(3,4); nrk = length(alpha); % time stepping info for full moment field eqns
if strcmpi(cascade_type,'filling')
    ld_i(1:ncascades) = 5e-6;
else
    ld_i = zeros(1,ncascades);
    ld_i(1) = ld_1;
    for i = 2:ncascades
        ld_i(i) = ld_i(i-1)/14;
    end
end
%---------------------
% functions
%---------------------
So       = @(t,Uo,q,g) (3875*10^(4/21)*21^(2/3)*lambda*Uo^4*((133*q + 100)/(151*q + 100))^(1/2)*...
         (9*q + 5)*(151*q + 100)^(3/7)*((g*t)/Uo)^((31*q)/7 - 3/7))/...
         (87127488*g^2*t*((151*q + 100)^(3/7)*((g*t)/Uo)^((3*q)/7 - 3/7))^(13/3));
S1       = @(t,Uo,q,g) (155*10^(1/3)*21^(2/3)*Uo^3*lambda*((133*q + 100)/(151*q + 100))^(1/2)*...
         (2*q + 1)*(151*q + 100)^(6/7)*((g*t)/Uo)^((27*q)/7 - 6/7))/...
         (592704*g*t*((151*q + 100)^(3/7)*((g*t)/Uo)^((3*q)/7 - 3/7))^(13/3));
Alpha    =  @(t,Uo,q,g) (31*10^(16/21)*21^(2/3)*((133*q + 100)/(151*q + ...
          100))^(1/2)*((151*q + 100)^(3/7)*((g*t)/Uo)^((3*q)/7 ...
          - 3/7))^(2/3))/25000;
E        = @(t,Uo,q,g) (31*Uo^4*lambda*(((133*q)/100 + 1)/((151*q)/100 + 1))^(1/2)*...
          ((g*t)/Uo)^(4*q))/(1000*g^2*((84*((151*q)/100 +...
          1)^(3/7)*((g*t)/Uo)^((3*q)/7 - 3/7))/5)^(10/3));     
U10      = @(t,Uo,q,g) Uo.*(g.*t./Uo).^q;
dudt     = @(t,Uo,q,g) g*q.*(g.*t./Uo).^(q-1);
Theta    = @(t,To,r,Tref) To.*(Tref.*t./To).^r;
Fm       = @(t,Uo,q,g) (42*10^(1/7)*g*(151*q + 100)^(3/7))/...
            (25*Uo*((g*t)/Uo)^((4*q)/7 + 3/7));
Nu       = @(fp,U,g)  fp.*U./g;     
epsilon  = @(Ed,U,g)  Ed*g^2/U^4;
P1       = @(p,U,rho) p - rho/2*(abs(U))^2;
Cg       = @(fp,g)    g./(4.*pi.*fp);
%---------------------
% Wind data
%---------------------
if strcmpi(wind_type,'dgwave')

elseif strcmpi(wind_type,'ndbc')
    if strcmpi(year,'2015')
        wind_data_2015
    elseif strcmpi(year,'2011')
        wind_data_2011
    elseif strcmpi(year,'2010')
        wind_data_2010
    elseif strcmpi(year,'2013')
        wind_data_2013
    elseif strcmpi(year,'2012')
        wind_data_2012
    elseif strcmpi(year,'2004')
        wind_data_2004
    elseif strcmpi(year,'2012_44065')
        wind_data_44065
    elseif strcmpi(year,'2005_42001')
        wind_data_42001
    end
    Uavg = Uoriginal;
else
    display('wind type incorrect, check file and wind_type')
end
if strcmpi(cascades,'on')
    dt_n = zeros(ncascades,1);
    ln_casc = zeros(ncascades,1);
    lw_casc = (Lw-1)*2;
    ln_casc(1) = lw_casc;
    for n = 1:ncascades-1
        lw_casc = (lw_casc-1)*2;
        ln_casc(n+1) = lw_casc;
    end
else
    lw_casc = Lw;
end
Nhrs    = (N*data_dt)/60;       % Hours of data
T       = N*data_dt*60;         % End time
deltat  = 60/2;                 % freq-int time step
dt      = data_dt*60;           % wind mixing length
NT      = floor(T/deltat)-1;    % # of time steps
NTw     = floor(dt/deltat);     % # of wind mixing intervals
%--------------------
% polynomial approx.
%--------------------
p = 0;                 
ndof = (p+1)*(p+2)/2;
%--------------------
% read in mesh data
%--------------------
simplex_read_mesh
%--------------------
% basis functions
%--------------------
freq_int_simplex_basis
%-------------------------
% Initialize Variables
%-------------------------
Uo        = zeros(Lw-1,nnodes);              % Ref. velocity of wind
q         = zeros(Lw-1,nnodes);              % Wind growth exponent
To        = zeros(Lw-1,nnodes);              % Ref. wind direction
r         = zeros(Lw-1,nnodes);              % Wind turning exponent
quadrant  = zeros(Lw-1,nnodes);              % Wind quadrant
uwind     = zeros(nl,1);
vwind     = zeros(nl,1);
Udiss     = zeros(lw_casc,nnodes,ncascades);
Uparent   = zeros(lw_casc,nnodes,ncascades);
total_d   = zeros(lw_casc,nnodes);
Diss_wts  = zeros(Lw-1,2^(ncascades));
ei        = zeros(Lw-1,nnodes);
ef        = zeros(lw_casc,nnodes);
%----------------------------
% Temporal wind interpolation
%----------------------------
tic;
wind_interp_sd 
toc
energy_dissipation
if strcmpi(cascades,'on')
    tic;
    data_type = 'cascade';
    for n = 1:ncascades
        cascade
        Uo = zeros(Lw-1,nnodes);              % Ref. velocity of wind
        q  = zeros(Lw-1,nnodes);              % Wind growth exponent
        To = zeros(Lw-1,nnodes);              % Ref. wind direction
        r  = zeros(Lw-1,nnodes);
        quadrant = zeros(Lw-1,nnodes);
        wind_interp_sd
    end
    turbulent_dissipation
    toc;
end
if strcmpi(qstat,'on')
    q_stats;
end
%------------------
% write input files
%------------------
if strcmpi(ic_file,'on')
    write_wind_input(Uo,q,To,r,quadrant,dt)
end
%------------------
% wind plots
%------------------
if strcmpi(wind_fig,'on')
    wind_interp_plot
end
%----------------------------------
% Calculate significant wave height
%----------------------------------
calc_sig_wave_h