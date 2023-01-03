


%% ��ͬ�ص�����  �������е�Ԫ����Ȧ���Ըб�  ���滥�б�

overlay = -10:1:15;
Cross_MI_ratio = [];
Self_inductance_ratio = [];

for t = overlay
    [a, b] = cal_cross(1, t, 11);
    Self_inductance_ratio = [Self_inductance_ratio, a];
    Cross_MI_ratio = [Cross_MI_ratio, b];
end

% % ���滥�бȽ����mat ����origin��ͼ
% res_ratio = [overlay', Self_inductance_ratio',Cross_MI_ratio'];
% save('C:\Users\LRF\OneDrive\�ĵ�\WPT\PAPER\origin\matlab_record\CrossMI_Selfinductance_ratio.mat','res_ratio')


%%��������λ�û��е�ͼ
fig = figure('color','w');
title('��ͬ�ص����� �Ըб� ���滥�б�')
x = overlay;
yyaxis left
plot(x,Self_inductance_ratio','-r*');
hold on;
yyaxis right
plot(x,Cross_MI_ratio','-g.');

% legend �������½�
legend('Self_inductance_ratio', 'Cross_MI_ratio', 'Location', 'southeast');

xlabel(['�ص����'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
% frame = getframe(fig); % ��ȡframe
% img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
% path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';


