function [len, lent] = lengthvars1(ts)

% lengtvars.m defines the length of variables in structs.
% outputs : 
%   len  : length of variable x in one time step
%   lent : length of variable x in the time horizon
%
% addition :
%   lent.total : total length of variables

len.x = 1;
len.y = 1;
len.n = 1;
len.deln = 1;
len.wc = 1;
len.wd = 1;
len.betac = 1;
len.betad = 1;

lent.x = len.x * ts;
lent.y = len.y * ts;
lent.n = len.n * ts;
lent.wc = len.wc * ts;
lent.wd = len.wd * ts;
lent.betac = len.betac * ts;
lent.betad = len.betad * ts;
lent.deln = len.deln * ts;

lent.total = sum(cell2mat(struct2cell(lent)));
end