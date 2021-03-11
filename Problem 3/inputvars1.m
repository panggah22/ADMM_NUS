function inp = inputvars1(lent)

% inputvars.m defines the input location for each variable in structs.
% output :
%   inp  : input location of variable x
%
% addition :
%   inp.cont : input location of continuous variables
%   inp.intg : input location of integer variables

inp.x = 1:lent.x;
inp.y = inp.x(end) + (1:lent.y);
inp.wc = inp.y(end) + (1:lent.wc);
inp.wd = inp.wc(end) + (1:lent.wd);

inp.n = inp.wd(end) + (1:lent.n);
inp.deln = inp.n(end) + (1:lent.deln);

inp.cont = 1:inp.y(end);
inp.intg = inp.n(1) : inp.deln(end);

end