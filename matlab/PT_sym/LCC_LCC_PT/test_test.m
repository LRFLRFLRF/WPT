
clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2 M k
syms a3 a3g Css Ls a3_d1 w3
syms a4 a4g Csp L2 a4_d1 w4

% 设电感比  L1/Lp = r1     L2/Ls = r2   Cps*Cpp = t1
syms r1 r2  t1

eq1 = 1i*w1*a1 + (r1^0.5-t1^0.5)/2*1i*w2*a2 - (r1)^0.5*a2_d1 == a1_d1;
eq2 = 1i*w2*a2 - (r1)^0.5/2*1i*w1*a1 == a2_d1;


[a1t, a2t] = solve(eq1,eq2,a1_d1,a2_d1);



a1t = simplify(a1t, 'Steps', 10);
a1t_res = collect(a1t, a1)
pretty(a1t_res)


% a2t = simplify(a2t, 'Steps', 10);
% a2t_res = collect(a2t, a2)
% pretty(a2t_res)




