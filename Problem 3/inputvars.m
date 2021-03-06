function inp = inputvars(lent)

% inputvars.m defines the input location for each variable in structs.
% output :
%   inp  : input location of variable x
%
% addition :
%   inp.cont : input location of continuous variables
%   inp.intg : input location of integer variables

inp.x = 1:lent.x;
inp.y = inp.x(end) + (1:lent.y);
inp.yy = inp.y(end) + (1:lent.yy);
inp.wc = inp.yy(end) + (1:lent.wc);
inp.wd = inp.wc(end) + (1:lent.wd);
inp.q = inp.wd(end) + (1:lent.q);
inp.qq = inp.q(end) + (1:lent.qq);

inp.n = inp.qq(end) + (1:lent.n);
inp.deln = inp.n(end) + (1:lent.deln);
inp.betac = inp.deln(end) + (1:lent.betac);
inp.betad = inp.betac(end) + (1:lent.betad);

inp.cont = 1:inp.y(end);
inp.intg = inp.n(1) : inp.betad(end);

end