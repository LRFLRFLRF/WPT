
clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2 M RL
syms a3 a3g Css Ls a3_d1 w3

% �������г��Ƶ��
temp1 = 1/w1^2;
temp2 = 1/w2^2;
temp3 = 1/w3^2;

% q  dq/dt   d^2 q/dt^2�ı��ʽ
qcps_m = -1i*(Cps/2)^0.5*(a2-a2g);
qcps_d1_m = (a2+a2g)/(2*Lp)^0.5;
qcps_d2_m = (2/Lp)^0.5*(a2_d1-1i*(a2+a2g)/(2*(Lp*Cps)^0.5));

qcpp_m = -1i*(Cpp/2)^0.5*(a1-a1g);
qcpp_d1_m = (a1+a1g)/(2*L1)^0.5-qcps_d1_m;
qcpp_d2_m = (2/L1)^0.5*a1_d1-qcps_d2_m-1i*w1*qcpp_d1_m;


% eq2
eq2 = Lp*qcps_d2_m + qcps_m/Cps - qcpp_m/Cpp + RL*qcps_d1_m== 0;    % M*qcss_d2_m       + RL*qcps_d1_m

% �������
eq2_t = simplify(subs(eq2, [L1*Cpp, Lp*Cps, Ls*Css], [temp1, temp2, temp3]));

% ���a2_d1�Ľ� ��simplify����
simp_eq2_t = simplify(solve(eq2_t, a2_d1),'IgnoreAnalyticConstraints', true, 'Steps', 10);

% ��a3_d1Ϊ�Ա���չ��
a2_res = collect(simp_eq2_t, a2)
pretty(a2_res)




