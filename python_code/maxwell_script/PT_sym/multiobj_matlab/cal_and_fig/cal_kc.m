

%% 计算临界耦合系数kc

syms kc RL w1 L1 L2 M

%[266*1E-6, 6.5*1E-6]
%[152*1E-6, 14*1E-6]
L1andM = [59.52*1E-6, 3.7*1E-6];    % 给定的L1自感值 和 互感值  %双单元自感105.41   6.4*1E-6
%L1andM = [105.41*1E-6, 5.8*1E-6];    % 给定的L1自感值 和 互感值  %双单元自感105.41
%L1andM = [105.41*1E-6 + 59.52*1E-6, 5.8*1E-6];    % 给定的L1自感值 和 互感值  %双单元自感105.41

L2_range = [50*1E-6, 90*1E-6];    % L2测试范围  即绘图的横轴

fc = 4E+5;

figure('color','w')
% 计算改变L2时， RL的临界范围
k_m = M/sqrt(L1*L2);    % 这里计算双负载时就需要多乘一个sqrt(2)  ！！！！！！！！！！！！！！！！
Q1_m = (2-sqrt(4*(1-k_m^2)))^(-0.5);   % 极限条件是kc等于k  实际耦合系数恰好在边界kc处
RL_m = fc*2*pi*L2/Q1_m;
%%%%%%%%%%%%%%这段貌似有误  别用
% kc_m = M/sqrt(L1*L2);  %计算临界耦合系数
% RL_m = 0.5*kc*fc*2*pi*2*L2;  %根据L1 L2 M计算临界RL （是RL的最大值）
% RL_m = subs(RL_m, [kc],[kc_m]);
%%%%%%%%%%%%%%
RL_m = vpa(subs(RL_m, [L1, M],L1andM),4);
subplot(3,1,1)
y = sym(RL_m);
fplot(y,L2_range);
title(['RL临界值;  参数：L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%%计算在L2变化时， 临界互感系数kc
subplot(3,1,2)
RL = 10; %给定RL值
Q1 = fc*2*pi*L2/RL;
kc_m = sqrt(1-0.25*(2-Q1^(-2))^2);
% kc_m = Q1^(-1)*sqrt(1-0.25*Q1^(-2));
y = sym(kc_m);
fplot(y,L2_range);
title(['临界互感系数kc; RL给定值：', num2str(RL)]);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%%计算在L2变化时， 给定L1和M 的互感系数
subplot(3,1,3)
k_m = M/sqrt(L1*L2); % 这里计算双负载时就需要多乘一个sqrt(2)  ！！！！！！！！！！！！！！！！
k_m = vpa(subs(k_m, [L1, M],L1andM),4);
y = sym(k_m);
fplot(y,L2_range);
title(['工作耦合系数k12;  参数：L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

xlabel(['L2变化范围'],'fontsize',10);


%% 导出直origin！！！！！
clear;
syms kc RL w1 L1 L2 M

L1andM = [59.52*1E-6, 6.4*1E-6];    % 给定的L1自感值 和 互感值  %6.4的时候是独立tx
L1andM = [105.41*1E-6, 5.8*1E-6];    % 给定的L1自感值 和 互感值  %双单元自感105.41
%L1andM = [2*59.52*1E-6, 6.4*1E-6];    % 给定的L1自感值 和 互感值  %两个独立Tx
%L1andM = [105.41*1E-6 + 59.52*1E-6, 6.1*1E-6];    % 给定的L1自感值 和 互感值  %一个2x1阵列加一个Tx
L1andM = [2*105.41*1E-6, 5.8*1E-6];    % 给定的L1自感值 和 互感值  %两个2x1阵列
fc = 4E+5;
x_range = 50*1E-6: 1E-6: 90*1E-6;

%计算临界RL
k_m = sqrt(2)*M/sqrt(L1*L2);    % 这里计算双负载时就需要多乘一个sqrt(2)  ！！！！！！！！！！！！！！！！
Q1_m = (2-sqrt(4*(1-k_m^2)))^(-0.5);   % 极限条件是kc等于k  实际耦合系数恰好在边界kc处
RL_m = fc*2*pi*L2/Q1_m;
RL_m = vpa(subs(RL_m, [L1, M],L1andM),4);
RLlist = [];
for i = x_range
    RLlist = [RLlist; double(vpa(subs(RL_m, L2,i),4))];
end
rlzhi = double(vpa(subs(RL_m, L2,72.263E-6),4))

%计算临界耦合系数
RL = 10; %给定RL值
Q1 = fc*2*pi*L2/RL;
kc_m = sqrt(1-0.25*(2-Q1^(-2))^2);
kc_m = vpa(subs(kc_m, [],[]),4);
kclist = [];
for i = x_range
    kclist = [kclist; double(vpa(subs(kc_m, L2,i),4))];
end
kczhi = double(vpa(subs(kc_m, L2,72.263E-6),4))

% 计算实际耦合系数
k_m = sqrt(2)*M/sqrt(L1*L2);    % 这里计算双负载时就需要多乘一个sqrt(2)  ！！！！！！！！！！！！！！！！
k_m = vpa(subs(k_m, [L1, M],L1andM),4);
klist = [];
for i = x_range
    klist = [klist; double(vpa(subs(k_m, L2,i),4))];
end
kzhi = double(vpa(subs(k_m, L2,72.263E-6),4))

z1 = [x_range', RLlist, kclist, klist];

save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\kcRL_doubleArray_doubleRx.mat','z1');
disp('ok')

