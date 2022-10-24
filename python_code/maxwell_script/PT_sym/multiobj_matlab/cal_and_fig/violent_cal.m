%% ���ļ�������Ѽ������ȱ�ʱ����Ԫ��Ȧ�Ļ�����������
clear;

%% ��Ԫ�����Է���
% ͬ���ȱ�  ���Ѽ��
rd = 0.4;
%tw = [0.25, 0.5, 0.75, 1];
tw = 0.25:0.05:0.5;
res = [];
for t = tw
    sendN = round(15*rd/t);
    [a, b, c, d] = single_unit_plot(t, 0, sendN, 15, 1);
    res = [res; a, b, c(1,round(length(c)/2))];
end
save(['D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\fix rd',num2str(rd),'change tw.mat'],'res')

%%��������λ�û��е�ͼ
fig = figure('color','w');
title('����λ�û�����uH')
x = tw;
plot(x,mc(1,:)','-r.');
hold on; 
plot(x,mc(2,:)','-g.');
hold on;
plot(x,mc(3,:)','-b.');
hold on;
plot(x,mc(4,:)','-c.');

% legend �������½�
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['rd=',num2str(rd),';  ͬ���ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ���ȱ�,���Ѽ��  ����λ�û���; rd=',num2str(rd),'.png']); % ���浽����Ŀ¼��

%%������׼���������ͼ
fig = figure('color','w');
title('����λ�û�����uH')
x = tw;
plot(x,qua_area(1,:)','-r.');
hold on;
plot(x,qua_area(2,:)','-g.');
hold on;
plot(x,qua_area(3,:)','-b.');
hold on;
plot(x,qua_area(4,:)','-c.');

% legend �������½�
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['rd=',num2str(rd),';  ͬ���ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ���ȱ�,���Ѽ��  ׼���ȿ��ȱ�; rd=',num2str(rd),'.png']); % ���浽����Ŀ¼��


%%
% ͬ�Ѽ��  ����ȱ�
tw = 0.5;
%rd = [0.1, 0.3, 0.5, 0.7];
rd = 0.1:0.06:0.7;
mc = [];
qua_area = [];
for r = rd
    sendN = round(15*r/tw);
    overlay = 15*r;
    [a, b] = single_unit_plot(tw, overlay, sendN, r);
    mc = [mc, a];
    qua_area = [qua_area, b];
end

%%��������λ�û��е�ͼ
fig = figure('color','w');
title('����λ�û�����uH')
x = rd;
plot(x,mc(1,:)','-r.');
hold on;
plot(x,mc(2,:)','-g.');
hold on;
plot(x,mc(3,:)','-b.');
hold on;
plot(x,mc(4,:)','-c.');

% legend �������½�
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['tw=',num2str(tw),';  ͬ���ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ�Ѽ�࣬����ȱ�  ����λ�û���; tw=',num2str(tw),'.png']); % ���浽����Ŀ¼��

%%������׼���������ͼ
fig = figure('color','w');
title('����λ�û�����uH');
x = rd;
plot(x,qua_area(1,:)','-r.');
hold on;
plot(x,qua_area(2,:)','-g.');
hold on;
plot(x,qua_area(3,:)','-b.');
hold on;
plot(x,qua_area(4,:)','-c.');

% legend �������½�
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['tw=',num2str(tw),';  ͬ���ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ�Ѽ�࣬����ȱ�  ׼���ȿ��ȱ�; tw=',num2str(tw),'.png']); % ���浽����Ŀ¼��
