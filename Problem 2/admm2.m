function [xx, fval] = admm2(rho,ts,u)
%% MAIN PROGRAM
% ----------------------------------
% This program uses Mixed-Integer Quadratic Programming as the element in
% the objective function contains quadratic term

[len, lent] = lengthvars2(ts);
inp = inputvars2(lent);

%% Objective Function 
H1 = zeros(lent.total);
H1(inp.deln,inp.deln) = 2*50*eye(lent.deln);

H2 = zeros(lent.total);
H2(inp.y,inp.y) = 2*eye(lent.y);

H = H1 + ((rho/2) * H2);

f1 = zeros(lent.total,1);
f1(inp.x) = 5;
f1(inp.y) = 3;

f2 = zeros(lent.total,1);
f2(inp.y) = -2 * u(inp.y);

f = f1 + ((rho/2) * f2);


%% Bounds
lb = -inf(lent.total,1);
lb(inp.y) = 0;
lb(inp.n) = 0;

ub = inf(lent.total,1);
ub(inp.y) = 5;
ub(inp.n) = 8;

%% Define variable type (continuous and integer)
ctypenum = 67*ones(1,lent.total);
ctypenum(inp.intg) = 73;
ctype = char(ctypenum);

options = cplexoptimset('cplex');
options.display = 'on';

%% Put constraints here
%% Constraint 1
equ(1).Aeq = zeros(lent.x,lent.total);
equ(1).Aeq(:,inp.x) = eye(lent.x);
equ(1).Aeq(:,inp.y) = eye(lent.y);
equ(1).Aeq(:,inp.n) = 5*eye(lent.n);

equ(1).beq = 100*ones(lent.x,1);

%% Constraint 2
equ(2).Aeq = zeros(lent.deln,lent.total);
equ(2).Aeq(:,inp.deln) = eye(lent.deln);
equ(2).Aeq(:,inp.n) = time_relate(eye(len.n), -eye(len.n), ts);

equ(2).beq = zeros(lent.deln,1);

%% Concatenate constraints
if logical(exist('equ','var'))
    Cequ = cell(size(equ,2),1);
    Cbequ = Cequ;
    for i = 1:size(equ,2)
        Cequ{i} = equ(i).Aeq;
        Cbequ{i} = equ(i).beq;
    end
    Aeq = cell2mat(Cequ);
    beq = cell2mat(Cbequ);
else
    Aeq = []; beq = [];
end

if logical(exist('ineq','var'))
    Cineq = cell(size(ineq,2),1);
    Cbineq = Cineq;
    for i = 1:size(ineq,2)
        Cineq{i} = ineq(i).A;
        Cbineq{i} = ineq(i).b;
    end
    Aineq = cell2mat(Cineq);
    bineq = cell2mat(Cbineq);
else
    Aineq = []; bineq = [];
end

%% Simulate !
% Aeq = [] ; beq = [];
[xx, fval, exitflag, output] = cplexmiqp (H, f, Aineq, bineq, Aeq, beq,...
    [], [], [], lb, ub, ctype, [], options);

% res = extractresult(fval,xx,len,inp,ts);
end
