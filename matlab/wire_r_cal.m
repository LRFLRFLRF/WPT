

%% ������ȼ���

sig = 5.8*1E+07;   %ͭ�ĵ絼��
u0 = 4*pi*1E-07;   %��մŵ���
f = 50*1E+03;    %�Ƶ��
%%���㼯�����delta ��λm
delta = 1/sqrt(pi*f*u0*sig);
disp(['depth = ', num2str(delta*1E+3), 'mm'])

%% г��Ƶ�ʼ���
syms C L f

sol = simplify(solve(2*f*pi*sqrt(L*C) == 1,C));

L = 17.57E-6;
f = 100E+3;
sol = vpa(subs(sol),4)


