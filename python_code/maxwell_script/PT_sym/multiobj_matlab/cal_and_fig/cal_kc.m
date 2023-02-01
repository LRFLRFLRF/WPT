

%% �����ٽ����ϵ��kc

syms kc RL w1 L1 L2 M

%[266*1E-6, 6.5*1E-6]
%[152*1E-6, 14*1E-6]
L1andM = [59.52*1E-6, 3.7*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %˫��Ԫ�Ը�105.41   6.4*1E-6
%L1andM = [105.41*1E-6, 5.8*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %˫��Ԫ�Ը�105.41
%L1andM = [105.41*1E-6 + 59.52*1E-6, 5.8*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %˫��Ԫ�Ը�105.41

L2_range = [50*1E-6, 90*1E-6];    % L2���Է�Χ  ����ͼ�ĺ���

fc = 4E+5;

figure('color','w')
% ����ı�L2ʱ�� RL���ٽ緶Χ
k_m = M/sqrt(L1*L2);    % �������˫����ʱ����Ҫ���һ��sqrt(2)  ��������������������������������
Q1_m = (2-sqrt(4*(1-k_m^2)))^(-0.5);   % ����������kc����k  ʵ�����ϵ��ǡ���ڱ߽�kc��
RL_m = fc*2*pi*L2/Q1_m;
%%%%%%%%%%%%%%���ò������  ����
% kc_m = M/sqrt(L1*L2);  %�����ٽ����ϵ��
% RL_m = 0.5*kc*fc*2*pi*2*L2;  %����L1 L2 M�����ٽ�RL ����RL�����ֵ��
% RL_m = subs(RL_m, [kc],[kc_m]);
%%%%%%%%%%%%%%
RL_m = vpa(subs(RL_m, [L1, M],L1andM),4);
subplot(3,1,1)
y = sym(RL_m);
fplot(y,L2_range);
title(['RL�ٽ�ֵ;  ������L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%%������L2�仯ʱ�� �ٽ绥��ϵ��kc
subplot(3,1,2)
RL = 10; %����RLֵ
Q1 = fc*2*pi*L2/RL;
kc_m = sqrt(1-0.25*(2-Q1^(-2))^2);
% kc_m = Q1^(-1)*sqrt(1-0.25*Q1^(-2));
y = sym(kc_m);
fplot(y,L2_range);
title(['�ٽ绥��ϵ��kc; RL����ֵ��', num2str(RL)]);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%%������L2�仯ʱ�� ����L1��M �Ļ���ϵ��
subplot(3,1,3)
k_m = M/sqrt(L1*L2); % �������˫����ʱ����Ҫ���һ��sqrt(2)  ��������������������������������
k_m = vpa(subs(k_m, [L1, M],L1andM),4);
y = sym(k_m);
fplot(y,L2_range);
title(['�������ϵ��k12;  ������L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

xlabel(['L2�仯��Χ'],'fontsize',10);


%% ����ֱorigin����������
clear;
syms kc RL w1 L1 L2 M

L1andM = [59.52*1E-6, 6.4*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %6.4��ʱ���Ƕ���tx
L1andM = [105.41*1E-6, 5.8*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %˫��Ԫ�Ը�105.41
%L1andM = [2*59.52*1E-6, 6.4*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %��������Tx
%L1andM = [105.41*1E-6 + 59.52*1E-6, 6.1*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %һ��2x1���м�һ��Tx
L1andM = [2*105.41*1E-6, 5.8*1E-6];    % ������L1�Ը�ֵ �� ����ֵ  %����2x1����
fc = 4E+5;
x_range = 50*1E-6: 1E-6: 90*1E-6;

%�����ٽ�RL
k_m = sqrt(2)*M/sqrt(L1*L2);    % �������˫����ʱ����Ҫ���һ��sqrt(2)  ��������������������������������
Q1_m = (2-sqrt(4*(1-k_m^2)))^(-0.5);   % ����������kc����k  ʵ�����ϵ��ǡ���ڱ߽�kc��
RL_m = fc*2*pi*L2/Q1_m;
RL_m = vpa(subs(RL_m, [L1, M],L1andM),4);
RLlist = [];
for i = x_range
    RLlist = [RLlist; double(vpa(subs(RL_m, L2,i),4))];
end
rlzhi = double(vpa(subs(RL_m, L2,72.263E-6),4))

%�����ٽ����ϵ��
RL = 10; %����RLֵ
Q1 = fc*2*pi*L2/RL;
kc_m = sqrt(1-0.25*(2-Q1^(-2))^2);
kc_m = vpa(subs(kc_m, [],[]),4);
kclist = [];
for i = x_range
    kclist = [kclist; double(vpa(subs(kc_m, L2,i),4))];
end
kczhi = double(vpa(subs(kc_m, L2,72.263E-6),4))

% ����ʵ�����ϵ��
k_m = sqrt(2)*M/sqrt(L1*L2);    % �������˫����ʱ����Ҫ���һ��sqrt(2)  ��������������������������������
k_m = vpa(subs(k_m, [L1, M],L1andM),4);
klist = [];
for i = x_range
    klist = [klist; double(vpa(subs(k_m, L2,i),4))];
end
kzhi = double(vpa(subs(k_m, L2,72.263E-6),4))

z1 = [x_range', RLlist, kclist, klist];

save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\kcRL_doubleArray_doubleRx.mat','z1');
disp('ok')

