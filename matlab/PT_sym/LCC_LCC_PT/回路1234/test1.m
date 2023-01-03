



clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2 M k
syms a3 a3g Css Ls a3_d1 w3
syms a4 a4g Csp L2 a4_d1 w4 RL

% 带入固有谐振频率
temp1 = 1/w1^2;
temp2 = 1/w2^2;
temp3 = 1/w3^2;
temp4 = 1/w4^2;

% q  dq/dt   d^2 q/dt^2的表达式
qcps_m = -1i*Cps^0.5/2^0.5*(a2-a2g);
qcps_d1_m = (a2+a2g)/2^0.5/Lp^0.5;
qcps_d2_m = 2^0.5/Lp^0.5*(a2_d1-1i*(a2+a2g)/(2*Lp^0.5*Cps^0.5));

qcss_m = -1i*Css^0.5/2^0.5*(a3-a3g);
qcss_d1_m = (a3+a3g)/2^0.5/Ls^0.5;
qcss_d2_m = 2^0.5/Ls^0.5*(a3_d1-1i*(a3+a3g)/(2*Ls^0.5*Css^0.5));

qcpp_m = -1i*Cpp^0.5/2^0.5*(a1-a1g);
qcpp_d1_m = (a1+a1g)/2^0.5/L1^0.5;
qcpp_d2_m = 2^0.5/L1^0.5*(a1_d1-1i*(a1+a1g)/(2*L1^0.5*Cpp^0.5));

qcsp_m = -1i*Csp^0.5/2^0.5*(a4-a4g);
qcsp_d1_m = (a4+a4g)/2^0.5/L2^0.5;
qcsp_d2_m = 2^0.5/L2^0.5*(a4_d1-1i*(a4+a4g)/(2*L2^0.5*Csp^0.5));

% eq3
eq1 = L1*qcpp_d2_m + L1*qcps_d2_m + qcpp_m/Cpp + Rn*qcpp_d1_m + Rn*qcps_d1_m == 0;%+ Rn*qcpp_d1_m + Rn*qcps_d1_m 
eq2 = Lp*qcps_d2_m + qcps_m/Cps + M*qcss_d2_m - qcpp_m/Cpp == 0; % 
eq3 = Ls*qcss_d2_m + qcss_m/Css + M*qcps_d2_m - qcsp_m/Csp == 0; %
eq4 = L2*qcsp_d2_m + L2*qcss_d2_m + qcsp_m/Csp - RL*qcsp_d1_m - RL*qcss_d1_m == 0;%


[a1t, a2t, a3t, a4t] = solve(eq1,eq2,eq3,eq4,a1_d1,a2_d1,a3_d1,a4_d1);



% 带入变量
% a1t = simplify(subs(a1t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k, 0 ,0, 0, 0]));
% a1t = simplify(a1t, 'Steps', 10);
% a1t = simplify(subs(a1t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, a4g, a3g, a2g, a1g, (M^2-Lp*Ls), M/Lp^0.5/Ls^0.5], [temp1, temp2, temp3, temp4, 0 ,0, 0, 0, -1*Lp*Ls, k]));
% a1t = simplify(a1t, 'Steps', 10);
% a1t_res = collect(a1t, a1)
% pretty(a1t_res)


% a2t = simplify(subs(a2t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k, 0 ,0, 0, 0]));
% a2t = simplify(a2t, 'Steps', 10);
% a2t = simplify(subs(a2t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, a4g, a3g, a2g, a1g, (M^2-Lp*Ls), M/Lp^0.5/Ls^0.5,], [temp1, temp2, temp3, temp4, 0 ,0, 0, 0, -1*Lp*Ls, k]));
% a2t = simplify(a2t, 'Steps', 10);
% a2t_res = collect(a2t, a2)
% pretty(a2t_res)

% a3t = simplify(subs(a3t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k, 0 ,0, 0, 0]));
% a3t = simplify(a3t, 'Steps', 10);
% a3t = simplify(subs(a3t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, a4g, a3g, a2g, a1g, (M^2-Lp*Ls), M/Lp^0.5/Ls^0.5,], [temp1, temp2, temp3, temp4, 0 ,0, 0, 0, -1*Lp*Ls, k]));
% a3t = simplify(a3t, 'Steps', 10);
% a3t_res = collect(a3t, a3)
% pretty(a3t_res)


a4t = simplify(subs(a4t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k, 0 ,0, 0, 0]));
a4t = simplify(a4t, 'Steps', 10);
a4t = simplify(subs(a4t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, a4g, a3g, a2g, a1g, (M^2-Lp*Ls), M/Lp^0.5/Ls^0.5], [temp1, temp2, temp3, temp4, 0 ,0, 0, 0, -1*Lp*Ls, k]));
a4t = simplify(a4t, 'Steps', 10);
a4t_res = collect(a4t, a4)
pretty(a4t_res)


%% 求L1

syms t 

b = 0.5;
eq = b*(1+0.5*t)/t^0.5 == 1;
res = solve(eq, t)



