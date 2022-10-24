

%% �����ٽ����ϵ��kc

syms kc RL w1 L1 L2 M

%[266*1E-6, 6.5*1E-6]
%[152*1E-6, 14*1E-6]
L1andM = [152*1E-6, 0.7*17*1E-6];    % ������L1�Ը�ֵ �� ����ֵ
L2_range = [50*1E-6, 200*1E-6];    % L2���Է�Χ  ����ͼ�ĺ���


figure('color','w')
% ����ı�L2ʱ�� RL���ٽ緶Χ
kc_m = M/sqrt(L1*L2);  %�����ٽ����ϵ��
RL_m = 0.5*kc*5E+5*2*pi*2*L2;  %����L1 L2 M�����ٽ�RL ����RL�����ֵ��
RL_m = subs(RL_m, [kc],[kc_m]);
RL_m = vpa(subs(RL_m, [L1, M],L1andM),4);
subplot(3,1,1)
y = sym(RL_m);
fplot(y,L2_range);
title(['RL�ٽ�ֵ;  ������L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%%������L2�仯ʱ�� �ٽ绥��ϵ��kc
subplot(3,1,2)
RL = 30; %����RLֵ
kc_m = RL/(L2*5E+5*2*pi);
kc_m = vpa(subs(kc_m, [],[]),4);
y = sym(kc_m);
fplot(y,L2_range);
title(['�ٽ绥��ϵ��kc; RL����ֵ��', num2str(RL)]);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%%������L2�仯ʱ�� ����L1��M �Ļ���ϵ��
subplot(3,1,3)
k_m = M/sqrt(L1*L2);
k_m = vpa(subs(k_m, [L1, M],L1andM),4);
y = sym(k_m);
fplot(y,L2_range);
title(['�������ϵ��k12;  ������L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

xlabel(['L2�仯��Χ'],'fontsize',10);





