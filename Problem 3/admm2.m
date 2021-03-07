function [xx, fval, H1, f1] = admm2(relax,rho,ts,u,y_hat)
%% MAIN PROGRAM
% ----------------------------------
% This program uses Mixed-Integer Quadratic Programming as the element in
% the objective function contains quadratic term

[len, lent] = lengthvars2(ts);
inp = inputvars2(lent);

%% Objective Function
H1 = zeros(lent.total);
H2 = zeros(lent.total);
H2(inp.z,inp.z) = 2*eye(lent.z);

H = H1 + ((rho/2) * H2);

f1 = zeros(lent.total,1);
f1(inp.m) = 100;
f2 = zeros(lent.total,1);
f2(inp.z) = -2 * u(inp.z);

f = f1 + ((rho/2) * f2);

%% Bounds
lb = -inf(lent.total,1);
lb(inp.z) = 0;

ub = inf(lent.total,1);
ub(inp.z) = y_hat;

%% Define variable type (continuous and integer)
ctypenum = 67*ones(1,lent.total);
if ~relax
    ctypenum(inp.intg) = 73;
end
ctype = char(ctypenum);

options = cplexoptimset('cplex');
options.display = 'on';

%% Put constraints here

%% Constraint 2
equ(2).Aeq = zeros(lent.m,lent.total);
equ(2).Aeq(:,inp.m) = eye(lent.m);
equ(2).Aeq(:,inp.z) = eye(lent.z);

equ(2).beq = ones(lent.m,1) .* y_hat;

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
