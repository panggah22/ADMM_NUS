% To see the final values for the variable, please open X{1,iter} and
% X{2,iter}

clear; clc;
tic
ts = 6; % Set the time step
maxiter = 20; % Set maximum iteration
rhoset = [0.1, 1, 10]; % Penalty value for ADMM
tol = 10^-6; % tolerance
y_hat = [2 4 8 7 10]';
l_hat = [25 40 35 50 55]';

for pp = 1:length(rhoset) 
    rho = rhoset(pp);
    %% Taking inputs of every entity
    [len1, lent1] = lengthvars2(ts);
    inp1 = inputvars2(lent1);
    [len2, lent2] = lengthvars3(ts);
    inp2 = inputvars3(lent2);
    
    %% Initial values of X and U
    X1 = zeros(lent1.total,1);
    X1(inp1.y) = 1;
    
    X2 = zeros(lent2.total,1);
    X2(inp2.z) = 1;
    
    U1 = zeros(lent1.total,1);
    U1(inp1.y) = U1(inp1.y) + (X1(inp1.y) + X2(inp2.z))/2;
    
    U2 = zeros(lent2.total,1);
    U2(inp2.z) = U2(inp2.z) + (X2(inp2.z) + X1(inp1.y))/2;
    
    %% Run the ADMM
    X = cell(2,maxiter);
    U = cell(2,maxiter);
    X{1,1} = X1; U{1,1} = U1;
    X{2,1} = X2; U{2,1} = U2;
    
    % residual = zeros(1,maxiter);
    R = zeros(lent1.total,1); R(:,1) = 1;
    D = zeros(lent1.total,1); D(:,1) = 1;
    residual = 0;
    
    for iter = 2:maxiter
        fprintf('Iteration no. %d\n',iter);
        [argx1,fval1] = admm2(rho,ts,U{1,iter-1});
        [argx2,fval2] = admm3(rho,ts,U{2,iter-1});
        
        %% Update X and U
        X{1,iter} = argx1;
        X{2,iter} = argx2;
        
        % Update U1
        U{1,iter} = U{1,iter-1} - X{1,iter-1}/2;
        U{1,iter}(inp1.y) = U{1,iter}(inp1.y) + X{2,iter}(inp2.z) - X{2,iter-1}(inp2.z)/2;
        
        % Update U2
        U{2,iter} = U{2,iter-1} - X{2,iter-1}/2;
        U{2,iter}(inp2.z) = U{2,iter}(inp2.z) + X{1,iter}(inp1.y) - X{2,iter-1}(inp1.y)/2;
        
        %% Evaluate residual
        r = X{1,iter}(inp1.y) - X{2,iter}(inp2.z)/2;
        d = X{1,iter}(inp1.y) - X{1,iter-1}(inp1.y)/2 + X{2,iter}(inp2.z) - X{2,iter-1}(inp2.z)/2;
        
        residual(iter-1) = max(abs([r;d]));
        if  residual(iter-1)<= tol
            break
        end
    end
    
    figure;
    re = plot(residual,'LineWidth',1.5);
    title (['Convergence with \rho = ',num2str(rho)]);
    xlabel ('Iteration');
    ylabel ('Residual')
    
end
toc
