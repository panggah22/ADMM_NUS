function res = extractresult(fval,xx,len,inp,ts)
% Program to create output respective to the variable names
fnames  = {'x','y','yy','n','deln','q','qq','wc','wd','betac','betad'};
%% Extract result
for ii = 1:length(fnames)
    res.(fnames{ii}) = reshape(xx(inp.(fnames{ii})),len.(fnames{ii}),ts);
end
res.fval = fval;
end