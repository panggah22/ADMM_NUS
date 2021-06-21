function data = sample7()
%% Conversion to per unit
data.kvbase = 12.66;
data.mvabase = 1;
data.zbase = (data.kvbase^2)/data.mvabase;

%% Bus data
data.bus = [
%  bus   P       Q
    1	0.0     0.0
    2	40.4	30.0
    3	75.0	54.0
    4	30.0	22.0
    5	28.0	19.0
    6	145.0	104.0
    7	145.0	104.0

    ];

data.num_bus = size(data.bus,1); % number of buses
data.bus = [(1:data.num_bus)', data.bus]; % for internal numbering, in case buses uses ID
data.bus(:,3:4) = data.bus(:,3:4)./(data.mvabase*1000);

%% Defining the load
data.load = data.bus(data.bus(:,3)>0,:);
data.num_load = size(data.load,1);
data.load = [(1:data.num_load)' data.load];

data.loadcoeff = [0.556 0.487 0.452 0.443 0.405 0.462 0.542 0.652 0.712 0.75 0.723 0.7 0.69 0.81 0.86 0.872 0.861 0.855 0.832 0.724 0.667 0.657 0.623 0.584];
data.loadcoeff = data.loadcoeff * (1/max(data.loadcoeff));

%% Buses connected to higer voltage
data.subs = 1;
data.num_subs = size(data.subs,1);
subsbus = zeros(data.num_subs,1);
for ii = 1:data.num_subs
    subsbus(ii) = data.bus(data.bus(:,2)==data.subs(ii),1);
end

%% Branch data
data.branch = [
% From  to    r       x
    1	2	0.3811	0.1941
    2	3	0.0922	0.047
    3	4	0.0493	0.0251
    4	5	0.8189	0.2707
    4	6	0.1872	0.0619
    6	7	0.7113	0.2351
    ];

data.num_branch = size(data.branch,1);
fromto = zeros(data.num_branch,2);
for i = 1:data.num_branch % branch numbering
    fromto(i,1) = data.bus((data.bus(:,2) == data.branch(i,1)),1);
    fromto(i,2) = data.bus((data.bus(:,2) == data.branch(i,2)),1);
end
data.branch = [(1:data.num_branch)', fromto, data.branch];
data.branch(:,6:7) = data.branch(:,6:7)./data.zbase;

data.pv = [
    5  100
    7  100
    ];

data.num_pv = size(data.pv,1);
pvbus = zeros(data.num_pv,1);
for ii = 1:data.num_pv
    pvbus(ii) = data.bus(data.bus(:,2)==data.pv(ii,1),1);
end
data.pv = [(1:data.num_pv)', pvbus, data.pv];
data.pv(:,4) = data.pv(:,4)./(data.mvabase*1000);
data.pvcoeff = 1.1*[0 0 0 0 0 0 0.05 0.2 0.35 0.50 0.65 0.75 0.8 0.75 0.65 0.50 0.35 0.2 0.05 0 0 0 0 0];

%% CB data
data.cb = [
    3	50
    ];

data.num_cb = size(data.cb,1);
cbbus = zeros(data.num_cb,1);
for ii = 1:data.num_cb
    cbbus(ii) = data.bus(data.bus(:,2)==data.cb(ii,1),1);
end
data.cb = [(1:data.num_cb)', cbbus ,data.cb];
data.cb(:,4) = data.cb(:,4)./(data.mvabase*1000);

end