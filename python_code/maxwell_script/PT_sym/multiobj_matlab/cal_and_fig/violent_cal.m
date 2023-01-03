%% ���ļ�������Ѽ�����ȱ�ʱ����Ԫ��Ȧ�Ļ�����������
clear;
%% �����뾶 �� �������ȱ�
lpp = 10:1:15;
rd = 0.3:0.1:0.6;
tw = 1;
res = [];
for lp = lpp
    for r = rd
        lp
        r
        sendN = round(15*r/tw+1)
        [a, b, c, d] = single_unit_plot(tw, 0, sendN, lp, 1);
        res = [res; r, lp, a, b, c(1,round(length(c)/2))];
    end
end
save(['D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\change rd',num2str(rd(1)),'to',num2str(rd(2)),'change lpp',num2str(lpp(1)),'to',num2str(lpp(2)),'.mat'],'res')



%% ��Ԫ�����Է���
% ���ȱ�  ���Ѽ��
%tw = [0.25, 0.5, 0.75, 1];
tw = 0.25:0.025:0.5;
rd = 0.1:0.1:0.7;
res = [];
for r = rd
    for t = tw
        sendN = round(15*r/t+1);
        [a, b, c, d] = single_unit_plot(t, 0, sendN, 15, 1);
        res = [res; r, t, a, b, c(1,round(length(c)/2))];
    end
end

%save(['D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\fix rd',num2str(rd),'change tw.mat'],'res')
save(['D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\change rd',num2str(rd(1)),'to',num2str(rd(2)),'change tw',num2str(tw(1)),'to',num2str(tw(2)),'.mat'],'res')


%% ����ͼ
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
result1 = importdata('fix rd0.6change tw.mat');
result2 = importdata('fix rd0.4change tw.mat');

fig = figure('color','w');
title('�̶�rd �ı�tw')
x = tw;
%��y��
yyaxis left
plot(x,result1(:,1)','-r.','linewidth',3); % 0.6��Mc
hold on;
plot(x,result2(:,1)','-ro','linewidth',3); % 0.4��Mc
ylim([0, 1.6]);
ylabel(['׼�������򻥸���M_c [uH]'],'fontsize',20);

%��y��
yyaxis right
plot(x,result1(:,2)','-black.','linewidth',3);% 0.6��׼���ȿ�ȱ�
hold on;
plot(x,result2(:,2)','-blacko','linewidth',3);% 0.4��׼���ȿ�ȱ�
hold on;
ylabel(['׼���ȿ�ȱ�r_{eff} [%]'],'fontsize',20);
xlabel(['�Ѽ��t_w [cm]'],'fontsize',20);
ylim([0, 1]);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
set(gca,'FontSize',20);
% legend �������½�
legend(['r_d=0.6 M_c'], ...
    ['r_d=0.4 M_c'],...
    ['r_d=0.6 r_{eff}'],...
    ['r_d=0.4 r_{eff}'],...
    'Location', 'northeast');

%% ����ͼ
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
result = importdata('change rd0.1to0.7change tw0.25to0.5.mat');   %change rd0.3to0.4change tw0.25to0.275

figure('color','w');
title('�ı�rd �ı�tw  ׼�������򻥸���M_c')
plot3(result(:,1), result(:,2), result(:,3),'pr');
xlabel(['�����ȱ�r_d [%]'],'fontsize',20);
ylabel(['�Ѽ��t_w [cm]'],'fontsize',20);
zlabel(['׼�������򻥸���M_c [uH]'],'fontsize',20);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
set(gca, 'ZGrid', 'on');% ��ʾ����

figure('color','w');
title('�ı�rd �ı�tw  ׼���������ȱ�r_{eff}')
plot3(result(:,1), result(:,2), result(:,4),'pr');
xlabel(['�����ȱ�r_d [%]'],'fontsize',20);
ylabel(['�Ѽ��t_w [cm]'],'fontsize',20);
zlabel(['׼���������ȱ�r_{eff} [%]'],'fontsize',20);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
set(gca, 'ZGrid', 'on');% ��ʾ����

figure('color','w');
title('�ı�rd �ı�tw  ���ϵ��k')
plot3(result(:,1), result(:,2), result(:,5),'pr');
xlabel(['�����ȱ�r_d [%]'],'fontsize',20);
ylabel(['�Ѽ��t_w [cm]'],'fontsize',20);
zlabel(['���ϵ��k'],'fontsize',20);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
set(gca, 'ZGrid', 'on');% ��ʾ����

figure('color','w');
tri = delaunay(result(:,1),result(:,2));
trisurf(tri,result(:,1),result(:,2),result(:,3))
shading interp;
sf=fit([result(:,1),result(:,2)],result(:,3),'poly54');
plot(sf,[result(:,1),result(:,2)],result(:,3))


%% ��������λ�û��е�ͼ
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
xlabel(['rd=',num2str(rd),';  ͬ��ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ��ȱ�,���Ѽ��  ����λ�û���; rd=',num2str(rd),'.png']); % ���浽����Ŀ¼��

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
xlabel(['rd=',num2str(rd),';  ͬ��ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ��ȱ�,���Ѽ��  ׼���ȿ�ȱ�; rd=',num2str(rd),'.png']); % ���浽����Ŀ¼��


%%
% ͬ�Ѽ��  ���ȱ�
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
xlabel(['tw=',num2str(tw),';  ͬ��ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ�Ѽ�࣬���ȱ�  ����λ�û���; tw=',num2str(tw),'.png']); % ���浽����Ŀ¼��

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
xlabel(['tw=',num2str(tw),';  ͬ��ȱ�,���Ѽ��'],'fontsize',10);
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'ͬ�Ѽ�࣬���ȱ�  ׼���ȿ�ȱ�; tw=',num2str(tw),'.png']); % ���浽����Ŀ¼��

