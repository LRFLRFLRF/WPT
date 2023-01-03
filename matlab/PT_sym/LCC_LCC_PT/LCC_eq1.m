
% �������й�ʽ1�����ģ�����Ƶ�
clear
syms a1 a1g Cpp L1 a1_d1 w1 Rn
syms a2 a2g Cps Lp a2_d1 w2
syms  
% �������г��Ƶ��
temp1 = 1/w1^2;
temp2 = 1/w2^2;

% q  dq/dt   d^2 q/dt^2�ı��ʽ
qcpp_m = -1i*(Cpp/2)^0.5*(a1-a1g);
qcpp_d1_m = (a1+a1g)/(2*L1)^0.5;
qcpp_d2_m = (2/L1)^0.5*(a1_d1-1i*(a1+a1g)/(2*(L1*Cpp)^0.5));

qcps_m = -1i*(Cps/2)^0.5*(a2-a2g);
qcps_d1_m = (a2+a2g)/(2*Lp)^0.5;
qcps_d2_m = (2/Lp)^0.5*(a2_d1-1i*(a2+a2g)/(2*(Lp*Cps)^0.5));


% eq1
eq1 = L1*qcpp_d2_m + L1*qcps_d2_m + qcpp_m/Cpp== 0;

% �������
eq1_t = simplify(subs(eq1, [L1*Cpp, Lp*Cps], [temp1, temp2]));

% ���a1_d1�Ľ� ��simplify����
simp_eq1_t = simplify(solve(eq1_t, a1_d1),'IgnoreAnalyticConstraints', true, 'Steps', 10);
% ��a2_d1Ϊ�Ա���չ��
a1_d1_res = collect(simp_eq1_t, a2_d1)
pretty(a1_d1_res)


%%%%%%%%%%%%%%%%%%%
% a1_d1_res�г�ȥ����a2_d1��ʽʣ��Ĳ���   ���м�������a1Ϊ�Ա�����չ��
%temp_a1_d1_res = (w1*(a1*1i + a1g*1i))/2 + (L1^(1/2)*((a2*w2*1i)/2 +(a2g*w2*1i)/2))/Lp^(1/2) + (L1^(1/2)*(a1 - a1g)*1i)/(2*Cpp^(1/2)*(L1 - Rn));
temp_a1_d1_res = (w1*(a1*1i + a1g*1i))/2 + ((a1 - a1g)*1i)/(2*Cpp^(1/2)*L1^(1/2)) + (L1^(1/2)*((a2*w2*1i)/2 + (a2g*w2*1i)/2))/Lp^(1/2);
temp_a1_d1_res = simplify(temp_a1_d1_res, 'Steps', 10);

temp_a1_d1_res1 = collect(temp_a1_d1_res, a1);
temp_a1_d1_res1 = simplify(subs(temp_a1_d1_res1, [sqrt(Cpp)*sqrt(L1)], [1/w1]), 'Steps', 10);
pretty(temp_a1_d1_res1)

