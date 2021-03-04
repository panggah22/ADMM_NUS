# ADMM_NUS
---
This simulation is tested on Matlab 2019 and 2020 with CPLEX 12.10 optimization tool
---
There are two problem sets :
    Problem 1 and Problem 2, which Problem 2 is similar to Problem 1 but with more constraint and different objective function
    In each problem, the simulation is tested using centralized and ADMM method.
    
In centralized method, open centralized_complex.m and the variable result can be seen under struct "res"
In ADMM method, open ADMM.m and the objective value can be observed under "fv1" for the first entity and "fv2" for the second entity
    The variable is in "argx1" and "argx2" for the first and second entity
