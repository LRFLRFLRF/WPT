

%% 计算临界耦合系数kc

syms kc RL w1 L1 L2 M

%[266*1E-6, 6.5*1E-6]
%[152*1E-6, 14*1E-6]
L1andM = [152*1E-6, 0.7*17*1E-6];    % 给定的L1自感值 和 互感值
L2_range = [50*1E-6, 200*1E-6];    % L2测试范围  即绘图的横轴


figure('color','w')
% 计算改变L2时， RL的临界范围
kc_m = M/sqrt(L1*L2);  %计算临界耦合系数
RL_m = 0.5*kc*5E+5*2*pi*2*L2;  %根据L1 L2 M计算临界RL （是RL的最大值）
RL_m = subs(RL_m, [kc],[kc_m]);
RL_m = vpa(subs(RL_m, [L1, M],L1andM),4);
subplot(3,1,1)
y = sym(RL_m);
fplot(y,L2_range);
title(['RL临界值;  参数：L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%%计算在L2变化时， 临界互感系数kc
subplot(3,1,2)
RL = 30; %给定RL值
kc_m = RL/(L2*5E+5*2*pi);
kc_m = vpa(subs(kc_m, [],[]),4);
y = sym(kc_m);
fplot(y,L2_range);
title(['临界互感系数kc; RL给定值：', num2str(RL)]);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%%计算在L2变化时， 给定L1和M 的互感系数
subplot(3,1,3)
k_m = M/sqrt(L1*L2);
k_m = vpa(subs(k_m, [L1, M],L1andM),4);
y = sym(k_m);
fplot(y,L2_range);
title(['工作耦合系数k12;  参数：L1:', num2str(L1andM(1,1)*1E+6), 'uH;M:', num2str(L1andM(1,2)*1E+6), 'uH']);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

xlabel(['L2变化范围'],'fontsize',10);





