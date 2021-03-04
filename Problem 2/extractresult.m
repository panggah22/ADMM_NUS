function res = extractresult(fval,xx,len,inp,ts)
% Program to create output respective to the variable names

%% Extract result

res.fval = fval;
res.x = reshape(xx(inp.x),len.x,ts)';
res.y = reshape(xx(inp.y),len.y,ts)';
res.m = reshape(xx(inp.m),len.m,ts)';
res.n = reshape(xx(inp.n),len.n,ts+1)';
res.deln = reshape(xx(inp.deln),len.deln,ts)';

end