function plot_M(sweeplist,paralist,res1,Var, Mean, canshu4, zhunarea, decay)
%% ��ͼ ������
fig = figure('color','w');

x = sweeplist.start_p:sweeplist.lens:sweeplist.end_p;
x = x.*100;

[r, ~] = size(res1);
line_type = ['-r.', '-g.', '-b.', '-c.'];
for i = 1:r
    plot(x,res1(i,:)',line_type(i));
    hold on;
end

% �������е���ʾ��
u1l = 0:paralist.send_tw:paralist.send_tw*(paralist.send_N-1);
u1r = paralist.send_maxR*2:-paralist.send_tw:paralist.send_maxR*2-paralist.send_tw*(paralist.send_N-1);
u2l = u1l(1,:) - paralist.overlay + paralist.send_maxR*2;
u2r = u1r(1,:) - paralist.overlay + paralist.send_maxR*2;
u1l = u1l.*100;
u1r = u1r.*100;
u2l = u2l.*100;
u2r = u2r.*100;
yl =  ylim;
plot(u1l,yl(1,1)+0.005,'.','Color',rgb('teal'),'MarkerSize',10);
plot(u1r,yl(1,1)+0.005,'x','Color',rgb('teal'),'MarkerSize',10);
if paralist.array_num_y >= 2
    plot(u2l,yl(1,1)+0.01,'.','Color',rgb('magenta'),'MarkerSize',10);
    plot(u2r,yl(1,1)+0.01,'x','Color',rgb('magenta'),'MarkerSize',10);
end


% legend �������½�
paramer = [];
for i = 1:r
    paramer = [paramer, ['Var=',num2str(Var(i,1)),';Mean=',num2str(Mean(i,1))]];
end
legend(paramer, 'Location', 'northwest');
% 
% legend(['Var=',num2str(Var(1,1)),';Mean=',num2str(Mean(1,1))], ...
%     ['Var=',num2str(Var(2,1)),';Mean=',num2str(Mean(2,1))],...
%     ['Var=',num2str(Var(3,1)),';Mean=',num2str(Mean(3,1))],...
%     ['Var=',num2str(Var(4,1)),';Mean=',num2str(Mean(4,1))],...
%     'Location', 'southeast');

xlabel(['tw=',num2str(paralist.send_tw*100),';over=',num2str(paralist.overlay*100),';N=',num2str(paralist.send_N),...
    ';rd=',num2str(canshu4),';recR=',num2str(paralist.rec_maxR*100),';maxR=',...
    num2str(paralist.send_maxR*100), ';Quasi=', num2str(round(zhunarea,2)), ';Cop=', num2str(round(decay,2))],'fontsize',10);


title('������uH');
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ

path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\step2 maxR14\';
%  imwrite(img,[path,'tw=',num2str(paralist.send_tw*100),';over=',num2str(paralist.overlay*100),';N=',num2str(paralist.send_N),...
%      ';rd=',num2str(round(canshu4,2)),';recR=',num2str(paralist.rec_maxR*100),';maxR=',...
%      num2str(paralist.send_maxR*100), ';Qua=', num2str(round(zhunarea,2)*100),'%', ';Cop=', num2str(round(decay,2)),'.png']); % ���浽����Ŀ¼��

% % ����2x1���л��н����mat ����origin��ͼ
% double_unit_M = [x', res1'];
% save('C:\Users\LRF\OneDrive\�ĵ�\WPT\PAPER\origin\matlab_record\double_unit_M.mat','double_unit_M')

% % ������൥Ԫ���н����mat ����origin��ͼ
% left_unit_M = [x', res1'];
% save('C:\Users\LRF\OneDrive\�ĵ�\WPT\PAPER\origin\matlab_record\left_unit_M.mat','left_unit_M')
% 
% % �����Ҳ൥Ԫ���н����mat ����origin��ͼ
% x = x - paralist.overlay*100 + paralist.send_maxR*2*100;
% right_unit_M = [x', res1'];
% save('C:\Users\LRF\OneDrive\�ĵ�\WPT\PAPER\origin\matlab_record\right_unit_M.mat','right_unit_M')
end

