
% 方程组中公式1的耦合模方程推导
clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2
syms  
% 带入固有谐振频率
temp1 = 1/w1^2;
temp2 = 1/w2^2;

% q  dq/dt   d^2 q/dt^2的表达式
qcps_m = -1i*(Cps/2)^0.5*(a2-a2g);
qcps_d1_m = (a2+a2g)/(2*Lp)^0.5;
qcps_d2_m = (2/Lp)^0.5*(a2_d1-1i*(a2+a2g)/(2*(Lp*Cps)^0.5));

qcpp_m = -1i*(Cpp/2)^0.5*(a1-a1g);
qcpp_d1_m = (a1+a1g)/(2*L1)^0.5-qcps_d1_m;
qcpp_d2_m = (2/L1)^0.5*a1_d1-qcps_d2_m-1i*w1*qcpp_d1_m;


% eq1
eq1 = L1*qcpp_d2_m + L1*qcps_d2_m + qcpp_m/Cpp+ Rn*(qcpp_d1_m+qcps_d1_m)== 0;  % + Rn*(qcpp_d1_m+qcps_d1_m)

pretty(eq1)

% 带入变量
eq1_t = simplify(subs(eq1, [L1*Cpp, Lp*Cps], [temp1, temp2]))

% 求得a1_d1的解 并simplify化简
simp_eq1_t = simplify(solve(eq1_t, a1_d1),'IgnoreAnalyticConstraints', true, 'Steps', 10)
% 以a2_d1为自变量展开
a1_res = collect(simp_eq1_t, a1)
pretty(a1_res)




