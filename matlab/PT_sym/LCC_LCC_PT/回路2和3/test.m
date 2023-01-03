
clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2 M k
syms a3 a3g Css Ls a3_d1 w3
syms a4 a4g Csp L2 a4_d1 w4

% 设电感比  L1/Lp = r1     L2/Ls = r2   Cps*Cpp = t1
syms r1 r2  t1

eq2 = 1i*w2*a2 + 1i*k*w3*a3/2 - k*a3_d1 == a2_d1;
eq3 = 1i*w3*a3 + 1i*k*w2*a2/2 - k*a2_d1 == a3_d1;


[a2t, a3t] = solve(eq2,eq3,a2_d1,a3_d1);

% 
% a2t = simplify(a2t, 'Steps', 10);
% a2t_res = collect(a2t, a2)
% pretty(a2t_res)


a3t = simplify(a3t, 'Steps', 10);
a3t_res = collect(a3t, a3)
pretty(a3t_res)




