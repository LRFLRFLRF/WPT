
%% 执行阵列与接收线圈互感仿真    包含NSGA算法适应度函数计算

function [Var_mean, Mean_mean] = func_cal1(sweep, para)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面是一些测试参数  正常时注释掉

% paralist.send_maxR = 15;%
% paralist.send_tw = 1.71;%
% paralist.aux_tw = 0.27;%
% paralist.overlay = 1.63;
% paralist.send_N = 4;
% paralist.aux_N = 4;
% paralist.aux_maxR = 2;%
% paralist.rec_maxR = 5;%
% paralist.array_num_y = 2;
% 
% 
% sweeplist.start_p = paralist.rec_maxR;
% sweeplist.end_p = (paralist.send_maxR*4-paralist.overlay)/2;%
% sweeplist.steps = 10;
% sweeplist.start_z = 2;
% sweeplist.end_z = 15;%
% sweeplist.steps_z = 3;
% sweeplist.fixed_x = 15;%
% %sweeplist.fixed_z = 2/100;%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 计时
tic


%% 一些尺寸参数需要除以100  实现m和cm换算
paralist = para;
sweeplist = sweep;

paralist.send_maxR = double(paralist.send_maxR/100);%
paralist.send_tw = double(paralist.send_tw/100);%
paralist.aux_tw = double(paralist.aux_tw/100);%
paralist.overlay = double(paralist.overlay/100);
paralist.aux_maxR = double(paralist.aux_maxR/100);%
paralist.rec_maxR = double(paralist.rec_maxR/100);%

sweeplist.start_p = double(sweeplist.start_p/100);
sweeplist.end_p = double(sweeplist.end_p/100);%
sweeplist.start_z = double(sweeplist.start_z/100);
sweeplist.end_z = double(sweeplist.end_z/100);%
sweeplist.fixed_x = double(sweeplist.fixed_x/100);
paralist
sweeplist
%% 计算接收线圈在不同位置时的互磁通

% 扫描点为接收线圈中心点
start_p = sweeplist.start_p;
end_p = sweeplist.end_p;
steps = sweeplist.steps;

start_z = sweeplist.start_z;
end_z = sweeplist.end_z;
steps_z = sweeplist.steps_z;
% 固定x z轴坐标  只沿y方向扫描
fixed_x = sweeplist.fixed_x;
%fixed_z = sweeplist.fixed_z;

% 接收线圈平面的半径
rec_R = paralist.rec_maxR;

% 遍历得到一系列扫描点P
lens = (end_p-start_p)/steps;
lens_z = (end_z-start_z)/steps_z;
P_list = [];
for j = start_z:lens_z:end_z
    for i = start_p:lens:end_p
        P_list = [P_list; fixed_x,i,j, rec_R];
    end
end

% 计算接收区域内的磁通量
res = array_fi_cal1(paralist, P_list);
res1 = reshape(res, [steps+1, length(res)/(steps+1)]);
res1 = res1';


%% 计算评价指标
% 将结果单位转化成uH
res1 = res1*1E+6;  

% 按行计算平均值   即计算每个高度下的互感平均值
Mean = mean(res1, 2);
Mean_mean = mean(Mean);
% 按行计算方差   即计算每个高度下的方差波动
Var = var(res1,0,2);
Var_mean = mean(Var);



%% 绘图 并保存
fig = figure('color','w');
x = start_p:lens:end_p;
x = x.*100;
plot(x,res1(1,:)','-r.');
hold on;
plot(x,res1(2,:)','-g.');
hold on;
plot(x,res1(3,:)','-b.');
hold on;
plot(x,res1(4,:)','-c.');
hold on;
% legend 放在右下角
legend(['Var=',num2str(Var(1,1)),';Mean=',num2str(Mean(1,1))], ...
    ['Var=',num2str(Var(2,1)),';Mean=',num2str(Mean(2,1))],...
    ['Var=',num2str(Var(3,1)),';Mean=',num2str(Mean(3,1))],...
    ['Var=',num2str(Var(4,1)),';Mean=',num2str(Mean(4,1))],...
    'Location', 'southeast');

xlabel(['tw=',num2str(paralist.send_tw*100),';over=',num2str(paralist.overlay*100),';s_N=',num2str(paralist.send_N),...
    ';a_N=',num2str(paralist.aux_N),';aux_maxR=',num2str(paralist.aux_maxR*100)],'fontsize',10);

set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

frame = getframe(fig); % 获取frame
img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\img\';
imwrite(img,[path,'Var_',num2str(Var_mean),';Mean_',num2str(Mean_mean),'.png']); % 保存到工作目录下

Mean_mean = -1 * Mean_mean;

%% 显示运行时间
toc
disp(['times: ',num2str(toc)]);
%% 计算发射阵列的自感

% % matlab为理想长直导线，导线半径趋于零， 因此计算自感磁通时要偏移一个导线半径
% wire_R = 0/100;
% 
% % 以各线圈为待计算面得到P_list
% P_list = [];
% % 计算两单元线圈间阵列距离
% dupli_dis = paralist.send_maxR*2-paralist.overlay;
% for i = 1:paralist.array_num_y
%     
%     % 计算不同阵列中心的y坐标
%     y = (i-1)*dupli_dis + paralist.send_maxR;
%     
%     for j = 1:paralist.send_N
%         % 计算发射线圈每匝的半径
%         plane_R = paralist.send_maxR-(j-1)*paralist.send_tw;
%         % 根据每匝的位置和大小生成扫描列表
%         P_list = [P_list; fixed_x, y, wire_R, plane_R];
%     end
%     
%     for j = 1:paralist.aux_N
%         % 计算辅助线圈每匝的半径
%         plane_R = paralist.aux_maxR-(j-1)*paralist.aux_tw;
%         % 根据每匝的位置和大小生成扫描列表
%         P_list = [P_list; fixed_x, y, wire_R, plane_R];
%     end
% end
% 
% % 将上面得到的P_list待积分面输入  计算每个平面的磁通量
% fi_list = array_fi_cal1(paralist, P_list);
% % 每匝线圈所围平面的磁通都加在一起  即为发射阵列的自感总磁通
% fi_array = sum(fi_list)

end



