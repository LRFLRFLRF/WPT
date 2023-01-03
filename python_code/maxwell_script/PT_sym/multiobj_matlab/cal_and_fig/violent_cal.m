%% 本文件计算变匝间距或变宽度比时，单元线圈的互感特性曲线
clear;
%% 变最大半径 和 变绕组宽度比
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



%% 单元内特性仿真
% 变宽度比  变匝间距
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


%% 绘制图
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
result1 = importdata('fix rd0.6change tw.mat');
result2 = importdata('fix rd0.4change tw.mat');

fig = figure('color','w');
title('固定rd 改变tw')
x = tw;
%左y轴
yyaxis left
plot(x,result1(:,1)','-r.','linewidth',3); % 0.6的Mc
hold on;
plot(x,result2(:,1)','-ro','linewidth',3); % 0.4的Mc
ylim([0, 1.6]);
ylabel(['准均匀区域互感量M_c [uH]'],'fontsize',20);

%右y轴
yyaxis right
plot(x,result1(:,2)','-black.','linewidth',3);% 0.6的准均匀宽度比
hold on;
plot(x,result2(:,2)','-blacko','linewidth',3);% 0.4的准均匀宽度比
hold on;
ylabel(['准均匀宽度比r_{eff} [%]'],'fontsize',20);
xlabel(['匝间距t_w [cm]'],'fontsize',20);
ylim([0, 1]);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
set(gca,'FontSize',20);
% legend 放在右下角
legend(['r_d=0.6 M_c'], ...
    ['r_d=0.4 M_c'],...
    ['r_d=0.6 r_{eff}'],...
    ['r_d=0.4 r_{eff}'],...
    'Location', 'northeast');

%% 绘制图
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
result = importdata('change rd0.1to0.7change tw0.25to0.5.mat');   %change rd0.3to0.4change tw0.25to0.275

figure('color','w');
title('改变rd 改变tw  准均匀区域互感量M_c')
plot3(result(:,1), result(:,2), result(:,3),'pr');
xlabel(['绕组宽度比r_d [%]'],'fontsize',20);
ylabel(['匝间距t_w [cm]'],'fontsize',20);
zlabel(['准均匀区域互感量M_c [uH]'],'fontsize',20);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
set(gca, 'ZGrid', 'on');% 显示网格

figure('color','w');
title('改变rd 改变tw  准均匀区域宽度比r_{eff}')
plot3(result(:,1), result(:,2), result(:,4),'pr');
xlabel(['绕组宽度比r_d [%]'],'fontsize',20);
ylabel(['匝间距t_w [cm]'],'fontsize',20);
zlabel(['准均匀区域宽度比r_{eff} [%]'],'fontsize',20);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
set(gca, 'ZGrid', 'on');% 显示网格

figure('color','w');
title('改变rd 改变tw  耦合系数k')
plot3(result(:,1), result(:,2), result(:,5),'pr');
xlabel(['绕组宽度比r_d [%]'],'fontsize',20);
ylabel(['匝间距t_w [cm]'],'fontsize',20);
zlabel(['耦合系数k'],'fontsize',20);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
set(gca, 'ZGrid', 'on');% 显示网格

figure('color','w');
tri = delaunay(result(:,1),result(:,2));
trisurf(tri,result(:,1),result(:,2),result(:,3))
shading interp;
sf=fit([result(:,1),result(:,2)],result(:,3),'poly54');
plot(sf,[result(:,1),result(:,2)],result(:,3))


%% 绘制中心位置互感的图
fig = figure('color','w');
title('中心位置互感量uH')
x = tw;
plot(x,mc(1,:)','-r.');
hold on;
plot(x,mc(2,:)','-g.');
hold on;
plot(x,mc(3,:)','-b.');
hold on;
plot(x,mc(4,:)','-c.');

% legend 放在右下角
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['rd=',num2str(rd),';  同宽度比,变匝间距'],'fontsize',10);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
frame = getframe(fig); % 获取frame
img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'同宽度比,变匝间距  中心位置互感; rd=',num2str(rd),'.png']); % 保存到工作目录下

%%绘制中准均匀区域的图
fig = figure('color','w');
title('中心位置互感量uH')
x = tw;
plot(x,qua_area(1,:)','-r.');
hold on;
plot(x,qua_area(2,:)','-g.');
hold on;
plot(x,qua_area(3,:)','-b.');
hold on;
plot(x,qua_area(4,:)','-c.');

% legend 放在右下角
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['rd=',num2str(rd),';  同宽度比,变匝间距'],'fontsize',10);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
frame = getframe(fig); % 获取frame
img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'同宽度比,变匝间距  准均匀宽度比; rd=',num2str(rd),'.png']); % 保存到工作目录下


%%
% 同匝间距  变宽度比
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

%%绘制中心位置互感的图
fig = figure('color','w');
title('中心位置互感量uH')
x = rd;
plot(x,mc(1,:)','-r.');
hold on;
plot(x,mc(2,:)','-g.');
hold on;
plot(x,mc(3,:)','-b.');
hold on;
plot(x,mc(4,:)','-c.');

% legend 放在右下角
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['tw=',num2str(tw),';  同宽度比,变匝间距'],'fontsize',10);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
frame = getframe(fig); % 获取frame
img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'同匝间距，变宽度比  中心位置互感; tw=',num2str(tw),'.png']); % 保存到工作目录下

%%绘制中准均匀区域的图
fig = figure('color','w');
title('中心位置互感量uH');
x = rd;
plot(x,qua_area(1,:)','-r.');
hold on;
plot(x,qua_area(2,:)','-g.');
hold on;
plot(x,qua_area(3,:)','-b.');
hold on;
plot(x,qua_area(4,:)','-c.');

% legend 放在右下角
legend(['dis=',num2str(2)], ...
    ['dis=',num2str(4)],...
    ['dis=',num2str(6)],...
    ['dis=',num2str(8)],...
    'Location', 'southeast');
xlabel(['tw=',num2str(tw),';  同宽度比,变匝间距'],'fontsize',10);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
frame = getframe(fig); % 获取frame
img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\cal_quasi_area\';
imwrite(img,[path,'同匝间距，变宽度比  准均匀宽度比; tw=',num2str(tw),'.png']); % 保存到工作目录下

