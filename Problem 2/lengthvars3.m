function [len, lent] = lengthvars3(ts)

% lengtvars.m defines the length of variables in structs.
% outputs : 
%   len  : length of variable x in one time step
%   lent : length of variable x in the time horizon
%
% addition :
%   lent.total : total length of variables


len.z = 1;
len.m = 1;

lent.z = len.z * ts;
lent.m = len.m * ts;

lent.total = sum(cell2mat(struct2cell(lent)));
end