

clear
syms a2 a2g Cps Lp a2_d1 w2 M
syms a3 a3g Css Ls a3_d1 w3
syms a4 a4g Csp L2 a4_d1 w4


% 带入固有谐振频率

temp3 = 1/w3^2;
temp4 = 1/w4^2;


% q  dq/dt   d^2 q/dt^2的表达式
qcss_m = -1i*(Css/2)^0.5*(a3-a3g);
qcss_d1_m = (a3+a3g)/(2*Ls)^0.5;
qcss_d2_m = (2/Ls)^0.5*(a3_d1-1i*(a3+a3g)/(2*(Ls*Css)^0.5));

qcsp_m = -1i*(Csp/2)^0.5*(a4-a4g);
qcsp_d1_m = (a4+a4g)/(2*L2)^0.5;
qcsp_d2_m = (2/L2)^0.5*(a4_d1-1i*(a4+a4g)/(2*(L2*Csp)^0.5));

% eq4
eq4 = (L2)*qcsp_d2_m + L2*qcss_d2_m + qcsp_m/Csp == 0;

% 带入变量
eq4_t = simplify(subs(eq4, [Ls*Css, L2*Csp], [temp3, temp4]));

% 求得a4_d1的解 并simplify化简
simp_eq4_t = simplify(solve(eq4_t, a4_d1),'IgnoreAnalyticConstraints', true, 'Steps', 10);

% 以a3_d1为自变量展开
a4_d1_res = collect(simp_eq4_t, a3_d1)
pretty(a4_d1_res)

% a4_d1_res中除去含有a3_d1因式剩余的部分   进行继续的以a4为自变量的展开
temp_a4_d1_res = (w4*(a4*1i + a4g*1i))/2 + ((a4 - a4g)*1i)/(2*Csp^(1/2)*L2^(1/2)) + (L2^(1/2)*((a3*w3*1i)/2 + (a3g*w3*1i)/2))/Ls^(1/2);
temp_a4_d1_res = simplify(temp_a4_d1_res, 'Steps', 10);

temp_a4_d1_res1 = collect(temp_a4_d1_res, a4);
temp_a4_d1_res1 = simplify(subs(temp_a4_d1_res1, [sqrt(Csp)*sqrt(L2)], [1/w4]), 'Steps', 10)
pretty(temp_a4_d1_res1)


