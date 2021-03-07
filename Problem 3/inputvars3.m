function inp = inputvars1(lent)

% inputvars.m defines the input location for each variable in structs.
% output :
%   inp  : input location of variable x
%
% addition :
%   inp.cont : input location of continuous variables
%   inp.intg : input location of integer variables

inp.q = 1:lent.q;
inp.qq = inp.q(end) + (1:lent.qq);
inp.wc = inp.qq(end) + (1:lent.wc);
inp.wd = inp.wc(end) + (1:lent.wd);

inp.cont = 1:inp.wd(end);
% inp.intg = inp.n(1) : inp.deln(end);

end