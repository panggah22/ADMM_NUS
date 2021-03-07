function [len, lent] = lengthvars1(ts)

% lengtvars.m defines the length of variables in structs.
% outputs : 
%   len  : length of variable x in one time step
%   lent : length of variable x in the time horizon
%
% addition :
%   lent.total : total length of variables

len.q = 1;
len.qq = 1;
len.wc = 1;
len.wd = 1;

lent.q = len.q * ts;
lent.qq = len.qq * ts;
lent.wc = len.wc * ts;
lent.wd = len.wd * ts;

lent.total = sum(cell2mat(struct2cell(lent)));
end