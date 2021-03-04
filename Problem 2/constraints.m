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
%     1.  x(t) + y(t) + 5n(t) = 100
%     2.  deln(t) - n(t) + n(t-1) = 0 ,  t > 1
%     3.  n(1) = 0   ... just assumption

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

%% Constraint 3
equ(3).Aeq = zeros(lent.m,lent.total);
equ(3).Aeq(:,inp.m) = eye(lent.m);
equ(3).Aeq(:,inp.y) = -eye(lent.y);

equ(3).beq = ones(lent.m,1) * -5;
