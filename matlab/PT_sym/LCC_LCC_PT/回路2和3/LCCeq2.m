
clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2 M RL
syms a3 a3g Css Ls a3_d1 w3

% 带入固有谐振频率
temp1 = 1/w1^2;
temp2 = 1/w2^2;
temp3 = 1/w3^2;

% q  dq/dt   d^2 q/dt^2的表达式
qcps_m = -1i*(Cps/2)^0.5*(a2-a2g);
qcps_d1_m = (a2+a2g)/(2*Lp)^0.5;
qcps_d2_m = (2/Lp)^0.5*(a2_d1-1i*(a2+a2g)/(2*(Lp*Cps)^0.5));

qcss_m = -1i*(Css/2)^0.5*(a3-a3g);
qcss_d1_m = (a3+a3g)/(2*Ls)^0.5;
qcss_d2_m = (2/Ls)^0.5*(a3_d1-1i*(a3+a3g)/(2*(Ls*Css)^0.5));

% eq2
eq2 = Lp*qcps_d2_m + qcps_m/Cps + M*qcss_d2_m== 0; 

% 带入变量
eq2_t = simplify(subs(eq2, [L1*Cpp, Lp*Cps, Ls*Css], [temp1, temp2, temp3]));

% 求得a3_d1的解 并simplify化简
simp_eq2_t = simplify(solve(eq2_t, a2_d1),'IgnoreAnalyticConstraints', true, 'Steps', 10);

%
a2_res = collect(simp_eq2_t, a3_d1)
pretty(a2_res)


%%%%%%%%
temp_a2_d1_res = (w2*(a2*1i + a2g*1i))/2 + ((a2 - a2g)*1i)/(2*Cps^(1/2)*Lp^(1/2)) + (M*((a3*w3*1i)/2 + (a3g*w3*1i)/2))/(Lp^(1/2)*Ls^(1/2));
temp_a2_d1_res = simplify(temp_a2_d1_res, 'Steps', 10);

temp_a2_d1_res1 = collect(temp_a2_d1_res, a2);
temp_a2_d1_res1 = simplify(subs(temp_a2_d1_res1, [sqrt(Cpp)*sqrt(L1)], [1/w1]), 'Steps', 10);
pretty(temp_a2_d1_res1)



