%% Main Program
clear;
timeslot = 13:18;
ts = length(timeslot);

data = sample7();
Pload = data.load(:,4) * data.loadcoeff(timeslot);

%% Declare Variables
Pg = sdpvar(data.num_subs,ts,'full');
Qg = sdpvar(data.num_subs,ts,'full');
Pline = sdpvar(data.num_branch,ts,'full');
Qline = sdpvar(data.num_branch,ts,'full');
Ppv = sdpvar(data.num_pv,ts,'full');
Qpv = sdpvar(data.num_pv,ts,'full');
Qcb = sdpvar(data.num_cb,ts,'full');
bcb = binvar(data.num_cb,ts,'full');

%% Define constraints
%% Constraint 3. Active power balance || eq. 10
% Searching for bus connection
buscon = cell(data.num_bus,4);
for ii = 1:data.num_bus
    buscon{ii,1} = data.bus(ii,1);
    buscon{ii,2} = data.branch(data.branch(:,3)==ii,1);
    buscon{ii,3} = data.branch(data.branch(:,2)==ii,1);
    buscon{ii,4} = data.subs(data.subs(:,1)==ii,1);
    buscon{ii,5} = data.pv(data.pv(:,2)==ii,1);
    buscon{ii,6} = data.load(data.load(:,2)==ii,1);
    buscon{ii,7} = data.cb(data.cb(:,2)==ii,1);
end

C{1} = [];
for ii = 1:data.num_bus
    multPg = zeros(1,data.num_subs); multPg(buscon{ii,4}) = 1;
    multPhi = zeros(1,data.num_branch); multPhi(buscon{ii,2}) = 1;
    multPij = zeros(1,data.num_branch); multPij(buscon{ii,3}) = 1;
    multPpv = zeros(1,data.num_pv); multPpv(buscon{ii,5}) = 1;
    multPload = zeros(1,data.num_load); multPload(buscon{ii,6}) = 1;
        
    C{1} = [C{1}, (multPg * Pg + multPpv * Ppv + sum(multPhi * Pline,1) - sum(multPij * Pline,1) ...
        == multPload * Pload):['Active Power flow ' num2str(ii)]];
end
sol = optimize(C{1})