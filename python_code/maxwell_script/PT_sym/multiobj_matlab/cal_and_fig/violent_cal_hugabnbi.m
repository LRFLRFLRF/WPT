


%% 不同重叠度下  计算阵列单元两线圈间自感比  交叉互感比

overlay = -10:1:15;
Cross_MI_ratio = [];
Self_inductance_ratio = [];

for t = overlay
    [a, b] = cal_cross(1, t, 11);
    Self_inductance_ratio = [Self_inductance_ratio, a];
    Cross_MI_ratio = [Cross_MI_ratio, b];
end

% % 保存互感比结果到mat 用于origin绘图
% res_ratio = [overlay', Self_inductance_ratio',Cross_MI_ratio'];
% save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\CrossMI_Selfinductance_ratio.mat','res_ratio')


%%绘制中心位置互感的图
fig = figure('color','w');
title('不同重叠度下 自感比 交叉互感比')
x = overlay;
yyaxis left
plot(x,Self_inductance_ratio','-r*');
hold on;
yyaxis right
plot(x,Cross_MI_ratio','-g.');

% legend 放在右下角
legend('Self_inductance_ratio', 'Cross_MI_ratio', 'Location', 'southeast');

xlabel(['重叠宽度'],'fontsize',10);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
% frame = getframe(fig); % 获取frame
% img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
% path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';


