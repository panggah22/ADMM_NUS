%% Create constraints here
% -----------------------
% The constraints should be written in specific struct (assume that the
% number of constraint is "a"
%     equ(a) is equality constraint number "a"
%     ineq(a) is inequality constraint number "a"
%
% Each struct has its own fields:
%     equ(a).Aeq or ineq(a).A contains variable matrix
%     equ(a).beq or ineq(a).b contains column vector of parameters
%
% Constraints:
%     1.  x(t) + y(t) + 5n(t) = l_hat
%     2.  deln(t) - n(t) + n(t-1) = 0 ,  t > 1
%     3.  n(0) = 0  
%     4.  yy(t) + y(t) = y_hat;

%% Constraint 1
equ(1).Aeq = zeros(lent.x,lent.total);
equ(1).Aeq(:,inp.x) = eye(lent.x);
equ(1).Aeq(:,inp.y) = eye(lent.y);
equ(1).Aeq(:,inp.n) = 5*eye(lent.n);

equ(1).beq = ones(lent.x,1) .* l_hat;

%% Constraint 2
equ(2).Aeq = zeros(lent.deln,lent.total);
equ(2).Aeq(:,inp.deln) = eye(lent.deln);
equ(2).Aeq(:,inp.n) = [-eye(len.n) zeros(len.n,lent.n-len.n); time_relate(eye(len.n), -eye(len.n), ts)];

equ(2).beq = zeros(lent.deln,1);

%% Constraint 3
equ(3).Aeq = zeros(lent.yy,lent.total);
equ(3).Aeq(:,inp.yy) = eye(lent.yy);
equ(3).Aeq(:,inp.y) = eye(lent.y);

equ(3).beq = ones(lent.yy,1) .* y_hat;

%% Constraint 4
equ(4).Aeq = zeros(lent.qq,lent.total);
equ(4).Aeq(:,inp.qq) = eye(lent.qq);
equ(4).Aeq(:,inp.q) = eye(lent.q);

equ(4).beq = ones(lent.qq,1) .* 0.8;

%% Constraint 5
equ(5).Aeq = zeros(lent.q,lent.total);
equ(5).Aeq(:,inp.q) = [-eye(len.q) zeros(len.q,lent.q-len.q); time_relate(eye(len.q), -eye(len.q), ts)];
equ(5).Aeq(:,inp.wc) = 0.05 .* -eye(lent.wc);
equ(5).Aeq(:,inp.wd) = 0.05*5 .* eye(lent.wd);

equ(5).beq = zeros(lent.q,1);
equ(5).beq(1:len.q) = 0.8;

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
