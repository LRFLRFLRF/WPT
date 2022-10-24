function plot_L(paralist,sweeplist, k,Var,Mean, canshu4, zhunarea, decay, L_array)

fig = figure('color','w');

x = sweeplist.start_p:sweeplist.lens:sweeplist.end_p;
x = x.*100;
[r, ~] = size(k);
line_type = ['-r.', '-g.', '-b.', '-c.'];
for i = 1:r
    plot(x,k(i,:)',line_type(i));
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

legend(paramer, 'Location', 'southeast');

% legend(['Var=',num2str(Var(1,1)),';Mean=',num2str(Mean(1,1))], ...
%     ['Var=',num2str(Var(2,1)),';Mean=',num2str(Mean(2,1))],...
%     ['Var=',num2str(Var(3,1)),';Mean=',num2str(Mean(3,1))],...
%     ['Var=',num2str(Var(4,1)),';Mean=',num2str(Mean(4,1))],...
%     'Location', 'southeast');

xlabel(['tw=',num2str(paralist.send_tw*100),';over=',num2str(paralist.overlay*100),';N=',num2str(paralist.send_N),...
    ';rd=',num2str(canshu4),';recR=',num2str(paralist.rec_maxR*100),';maxR=',...
    num2str(paralist.send_maxR*100), ';Quasi=', num2str(round(zhunarea,2)), ';Cop=', num2str(round(decay,2)),';L=',num2str(L_array,'%.2f'),'uH'],'fontsize',10);

%xlabel(['tw=',num2str(paralist.send_tw*100),';over=',num2str(paralist.overlay*100),';N=',num2str(paralist.send_N),...
%    ';rd=',num2str(canshu4),';recR=',num2str(paralist.rec_maxR*100),';maxR=',num2str(paralist.send_maxR*100),';L=',num2str(L_array,'%.2f'),'uH'],'fontsize',10);

title('���ϵ��k');
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ

path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\fuzai\';
%imwrite(img,[path,'K_Var_',num2str(Var_mean),';Mean_',num2str(Mean_mean),'.png']); % ���浽����Ŀ¼��
imwrite(img,[path,'tw=',num2str(paralist.send_tw*100),';over=',num2str(paralist.overlay*100),';N=',num2str(paralist.send_N),...
    ';rd=',num2str(round(canshu4,2)),';recR=',num2str(paralist.rec_maxR*100),';maxR=',...
    num2str(paralist.send_maxR*100), ';Qua=', num2str(round(zhunarea,2)*100),'%', ';Cop=', num2str(round(decay,2)), ';L=',num2str(L_array,'%.2f'),'uH','.png']); % ���浽����Ŀ¼��

end

