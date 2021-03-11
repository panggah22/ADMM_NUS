function [xx, fval, H1, f1] = admm1(relax,rho,ts,u,l_hat,y_hat)
%% MAIN PROGRAM
% ----------------------------------
% This program uses Mixed-Integer Quadratic Programming as the element in
% the objective function contains quadratic term

[len, lent] = lengthvars1(ts);
inp = inputvars1(lent);

%% Objective Function 
H1 = zeros(lent.total);
H1(inp.deln,inp.deln) = 2*50*eye(lent.deln);

H2 = zeros(lent.total);
H2(inp.y,inp.y) = 2*eye(lent.y);
H2(inp.wc,inp.wc) = 2*eye(lent.wc);
H2(inp.wd,inp.wd) = 2*eye(lent.wd);

H = H1 + ((rho/2) * H2);

f1 = zeros(lent.total,1);
f1(inp.x) = 5;
f1(inp.y) = 3;
f1(inp.wd) = 4;

f2 = zeros(lent.total,1);
f2(inp.y) = -2 * u(inp.y);
f2(inp.wc) = -2 * u(inp.wc);
f2(inp.wd) = -2 * u(inp.wd);

f = f1 + ((rho/2) * f2);


%% Bounds
lb = -inf(lent.total,1);
lb(inp.x) = 0;
lb(inp.n) = 0;

ub = inf(lent.total,1);
ub(inp.n) = 8;

%% Define variable type (continuous and integer)
ctypenum = 67*ones(1,lent.total);
if ~relax
    ctypenum(inp.intg) = 73;
end
ctype = char(ctypenum);

options = cplexoptimset('cplex');
options.display = 'on';

%% Put constraints here
%% Constraint 1
equ(1).Aeq = zeros(lent.x,lent.total);
equ(1).Aeq(:,inp.x) = eye(lent.x);
equ(1).Aeq(:,inp.y) = eye(lent.y);
equ(1).Aeq(:,inp.n) = 5*eye(lent.n);
equ(1).Aeq(:,inp.wd) = eye(lent.wd);
equ(1).Aeq(:,inp.wc) = -eye(lent.wc);

equ(1).beq = ones(lent.x,1) .* l_hat;

%% Constraint 2
equ(2).Aeq = zeros(lent.deln,lent.total);
equ(2).Aeq(:,inp.deln) = eye(lent.deln);
equ(2).Aeq(:,inp.n) = [-eye(len.n) zeros(len.n,lent.n-len.n); time_relate(eye(len.n), -eye(len.n), ts)];

equ(2).beq = zeros(lent.deln,1);

% %% Constraint 6
% ineq(6).A = zeros(lent.wc,lent.total);
% ineq(6).A(:,inp.wc) = eye(lent.wc);
% ineq(6).A(:,inp.betac) = 10 * -eye(lent.betac);
% 
% ineq(6).b = zeros(lent.wc,1);

% %% Constraint 7
% ineq(7).A = zeros(lent.wd,lent.total);
% ineq(7).A(:,inp.wd) = eye(lent.wd);
% ineq(7).A(:,inp.betad) = 10 * -eye(lent.betad);
% 
% ineq(7).b = zeros(lent.wd,1);

% %% Constraint 8
% ineq(8).A = zeros(lent.betac,lent.total);
% ineq(8).A(:,inp.betac) = eye(lent.betac);
% ineq(8).A(:,inp.betad) = eye(lent.betad);
% 
% ineq(8).b = ones(lent.betac,1) .* 1.5;

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
