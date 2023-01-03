
% �Ƶ������ģ������ ˫г���ӵĵ�������

%% �򻯰�
syms L1 L2
syms w1 w3  T lam g w2 ks1 ks2 
syms a1(t)  a2(t) a3(t) t;
eq1 = diff(a1, t) == (1i*w1+g)*a1 -1i*ks1*a2;
eq2 = diff(a2, t) == -1i*ks1*a1 +(1i*w2-T)*a2;
cond = [a1(0)==1, a2(0)==0];
[a1, a2] = dsolve(eq1, eq2, cond);
dqc1 = real(a1)/L1^0.5*2^0.5;
dqc2 = real(a2)/L2^0.5*2^0.5;
pretty(a1)

temp = simplify(rewrite(a1,'cos'))
pretty(temp)


% ��ͼ  г����1 �� 2 �ĵ���
g_m = -0E+2;
Rn = 20;
RL = 20;
L1_m =  10E-5;
L2_m =  1E-5;
w1_m = 1E+6;
w2_m = 1E+6;
K = 0.001;

x=[0:1E-6:6E-3];
T_m = RL/2/L2_m;
g_m = Rn/2/L1_m;

T_m = 1E+02;
g_m = T_m;
ks1_m = 0.5*K*(w1_m+w2_m)/2;


% ����ͼ��
figure();
dqc1 = vpa(subs(dqc1, [g,T, w1, w2, ks1, L1, L2], [g_m,T_m,w1_m, w2_m, ks1_m,L1_m, L2_m]))  %
z=subs(dqc1,t,x);
plot(x,z, 'r');
hold on;

dqc2 = vpa(subs(dqc2, [g,T, w1, w2, ks1, L1, L2], [g_m,T_m,w1_m, w2_m, ks1_m,L1_m, L2_m]))
z=subs(dqc2,t,x);
plot(x,z, 'b');
hold on;

% �����ѹͼ��
figure();
uL1 = vpa(subs(L1_m*diff(dqc1,t), [g,T, w1, w2, ks1, L1, L2], [g_m,T_m,w1_m, w2_m, ks1_m,L1_m, L2_m]))  %
z=subs(uL1,t,x);
plot(x,z, 'r');
hold on;

uRL = vpa(subs(L2_m*diff(dqc2,t), [g,T, w1, w2, ks1, L1, L2], [g_m,T_m,w1_m, w2_m, ks1_m,L1_m, L2_m]))
z=subs(uRL,t,x);
plot(x,z, 'b');
hold on;

