function inp = inputvars2(lent)

% inputvars.m defines the input location for each variable in structs.
% output :
%   inp  : input location of variable x
%
% addition :
%   inp.cont : input location of continuous variables
%   inp.intg : input location of integer variables

inp.m = 1:lent.m;
inp.z = inp.m(end) + (1:lent.z);

inp.cont = inp.m(end);
inp.intg = inp.z;

end