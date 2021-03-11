function [xx, fval, H1, f1] = admm3(relax,rho,ts,u)
%% MAIN PROGRAM
% ----------------------------------
% This program uses Mixed-Integer Quadratic Programming as the element in
% the objective function contains quadratic term

[len, lent] = lengthvars3(ts);
inp = inputvars3(lent);

%% Objective Function 
H1 = zeros(lent.total);
H1(inp.qq,inp.qq) = 2*200*eye(lent.qq);

H2 = zeros(lent.total);
H2(inp.wc,inp.wc) = 2*eye(lent.wc);
H2(inp.wd,inp.wd) = 2*eye(lent.wd);

H = H1 + ((rho/2) * H2);

f1 = zeros(lent.total,1);

f2 = zeros(lent.total,1);
f2(inp.wc) = -2 * u(inp.wc);
f2(inp.wd) = -2 * u(inp.wd);

f = f1 + ((rho/2) * f2);


%% Bounds
lb = -inf(lent.total,1);
lb(inp.q) = 0.4;
lb(inp.wc) = 0;
lb(inp.wd) = 0;
lb(inp.betac) = 0;
lb(inp.betad) = 0;

ub = inf(lent.total,1);
ub(inp.q) = 1;
ub(inp.betac) = 1;
ub(inp.betad) = 1;

%% Define variable type (continuous and integer)
ctypenum = 67*ones(1,lent.total);
if ~relax
    ctypenum(inp.intg) = 73;
end
ctype = char(ctypenum);

options = cplexoptimset('cplex');
options.display = 'on';

%% Put constraints here

%% Constraint 4
equ(4).Aeq = zeros(lent.qq,lent.total);
equ(4).Aeq(:,inp.qq) = eye(lent.qq);
equ(4).Aeq(:,inp.q) = eye(lent.q);

equ(4).beq = ones(lent.qq,1) .* 0.8;

%% Constraint 5
equ(5).Aeq = zeros(lent.q,lent.total);
equ(5).Aeq(:,inp.q) = [-eye(len.q) zeros(len.q,lent.q-len.q); time_relate(eye(len.q), -eye(len.q), ts)];
equ(5).Aeq(:,inp.wc) = 0.05 .* -eye(lent.wc);
equ(5).Aeq(:,inp.wd) = 0.05 .* eye(lent.wd);

equ(5).beq = zeros(lent.q,1);
equ(5).beq(1:len.q) = -0.8;

%% Constraint 6
ineq(6).A = zeros(lent.wc,lent.total);
ineq(6).A(:,inp.wc) = eye(lent.wc);
ineq(6).A(:,inp.betac) = 10 * -eye(lent.betac);

ineq(6).b = zeros(lent.wc,1);

%% Constraint 7
ineq(7).A = zeros(lent.wd,lent.total);
ineq(7).A(:,inp.wd) = eye(lent.wd);
ineq(7).A(:,inp.betad) = 10 * -eye(lent.betad);

ineq(7).b = zeros(lent.wd,1);

%% Constraint 8
ineq(8).A = zeros(lent.betac,lent.total);
ineq(8).A(:,inp.betac) = eye(lent.betac);
ineq(8).A(:,inp.betad) = eye(lent.betad);

ineq(8).b = ones(lent.betac,1) .* 1.5;

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
