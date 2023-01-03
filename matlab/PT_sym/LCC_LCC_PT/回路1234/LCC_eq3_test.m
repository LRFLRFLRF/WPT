



clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2 M 
syms a3 a3g Css Ls a3_d1 w3
syms a4 a4g Csp L2 a4_d1 w4 RL

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

qcsp_m = -1i*(Csp/2)^0.5*(a4-a4g);
qcsp_d1_m = (a4+a4g)/(2*L2)^0.5-qcss_d1_m;
qcsp_d2_m = (2/L2)^0.5*a4_d1-qcss_d2_m-1i*w4*qcsp_d1_m;

% eq3
eq3 = Ls*qcss_d2_m + qcss_m/Css + M*qcps_d2_m - qcsp_m/Csp== 0; 

% 带入变量
eq3_t = simplify(subs(eq3, [L1*Cpp, Lp*Cps, Ls*Css], [temp1, temp2, temp3]));

% 求得a3_d1的解 并simplify化简
simp_eq3_t = simplify(solve(eq3_t, a3_d1),'IgnoreAnalyticConstraints', true, 'Steps', 10);

%
a3_res = collect(simp_eq3_t, a2_d1)
pretty(a3_res)


%%%%%%%%
temp_a3_d1_res = (w3*(a3*1i + a3g*1i))/2 - ((a4 - a4g)*1i)/(2*Csp^(1/2)*Ls^(1/2)) + ((a3 - a3g)*1i)/(2*Css^(1/2)*Ls^(1/2)) + (M*((a2*w2*1i)/2 + (a2g*w2*1i)/2))/(Lp^(1/2)*Ls^(1/2));
temp_a3_d1_res = simplify(temp_a3_d1_res, 'Steps', 10);

temp_a3_d1_res1 = collect(temp_a3_d1_res, a3);
temp_a3_d1_res1 = simplify(subs(temp_a3_d1_res1, [sqrt(Cpp)*sqrt(L1)], [1/w1]), 'Steps', 10);
pretty(temp_a3_d1_res1)









