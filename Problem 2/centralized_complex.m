%% MAIN PROGRAM
% ----------------------------------
% This program uses Mixed-Integer Quadratic Programming as the element in
% the objective function contains quadratic term

clear; tic;
ts = 5;
[len, lent] = lengthvars(ts);
inp = inputvars(lent);
y_hat = [2 4 8 7 10]';
l_hat = [25 40 35 50 55]';

%% Objective Function 
H = zeros(lent.total);
H(inp.deln,inp.deln) = 2*50*eye(lent.deln);

f = zeros(lent.total,1);
f(inp.x) = 5;
f(inp.y) = 3;
f(inp.m) = 100;

%% Bounds
lb = -inf(lent.total,1);
lb(inp.x) = 0;
lb(inp.y) = 0;
lb(inp.n) = 0;

ub = inf(lent.total,1);
ub(inp.y) = y_hat;
ub(inp.n) = 8;

%% Define variable type (continuous and integer)
ctypenum = 67*ones(1,lent.total);
ctypenum(inp.intg) = 73;  % Comment this if want relaxed integer
ctype = char(ctypenum);

options = cplexoptimset('cplex');
options.display = 'on';

%% Put constraints here
constraints;

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

res = extractresult(fval,xx,len,inp,ts);
