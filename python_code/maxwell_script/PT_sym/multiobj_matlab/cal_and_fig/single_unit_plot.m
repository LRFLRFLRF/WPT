%% 计算单个发射单元互感特性  并绘图
% 包括计算不同尺寸线圈的互感  计算自感  计算耦合系数   以及绘图
function [Mc, zhunarea, k, res1] = single_unit_plot(canshu1, canshu2, canshu3, canshu4, canshu5)
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');
%%设定线圈参数及仿真参数
para.send_maxR = canshu4; %最大半径15cm
para.send_tw = canshu1;%0.5; %绕组匝间距
para.aux_tw = 0;  %辅助线圈匝间距
para.overlay = canshu2;%10;   %阵列单元重叠度
para.send_N = canshu3;    % 发射线圈匝数
para.aux_N = 0;
para.aux_maxR = 0;%
para.rec_maxR = 5;%     %接收线圈最大半径
para.array_num_y = canshu5;   % 阵列单元数

sweep.start_p = -10;    % 扫描起始点
%sweep.end_p = para.array_num_y*(2*para.send_maxR-para.overlay)+10;  % 扫描中止点
sweep.end_p = para.array_num_y*2*para.send_maxR - (para.array_num_y-1)*para.overlay+10;  % 扫描中止点
sweep.steps = 45*para.array_num_y;   % 扫描点数 
sweep.start_z = 5; %2   %z方向扫描起始点    
sweep.end_z = 5;  %8  %z方向扫描中止点
sweep.steps_z = 0;  %3   %z方向扫描点数
sweep.fixed_x = para.send_maxR;%   %接收线圈的y轴坐标   即收发装置y轴对准

%% 处理函数 这些基本不需要动  就是把前面设定的数据进行一个转化
%% 一些尺寸参数需要除以100  实现m和cm换算
% paralist = para;
% sweeplist = sweep;
% paralist.send_maxR = double(paralist.send_maxR/100);%
% paralist.send_tw = double(paralist.send_tw/100);%
% paralist.aux_tw = double(paralist.aux_tw/100);%
% paralist.overlay = double(paralist.overlay/100);
% paralist.aux_maxR = double(paralist.aux_maxR/100);%
% paralist.rec_maxR = double(paralist.rec_maxR/100);%
% sweeplist.start_p = double(sweeplist.start_p/100);
% sweeplist.end_p = double(sweeplist.end_p/100);%
% sweeplist.start_z = double(sweeplist.start_z/100);
% sweeplist.end_z = double(sweeplist.end_z/100);%
% sweeplist.fixed_x = double(sweeplist.fixed_x/100);
% 
% % 计算扫描步长
% sweeplist.lens = (sweeplist.end_p-sweeplist.start_p)/sweeplist.steps;
% sweeplist.lens_z = (sweeplist.end_z-sweeplist.start_z)/sweeplist.steps_z;

[paralist,sweeplist] = transform_para(para,sweep);


%% 计算接收线圈在不同位置时的互磁通
res1 = cal_unit_M(paralist,sweeplist);


%% 计算准均匀区域大小
[r,c]=size(res1);


% 找极大值点和极小值点
extrMaxValue = res1(find(diff(sign(diff(res1)))==-2)+1);
extrMinValue = res1(find(diff(sign(diff(res1)))==+2)+1);
extrMinValue = extrMinValue(2:end-1);
if isempty(extrMinValue)
    cent_L = res1(:,round(c/2));   %单元中心位置的互感量
else
    cent_L = (mean(extrMaxValue)+mean(extrMinValue))/2;   % 以局部极大值、极小值的平均数作为基准
end


cond_l = cent_L.*0.95;    %计算15%偏差时的下界
cond_h = cent_L.*1.05;    %计算15%偏差时的上界


area_num = [];
for i = 1:r
    js = 0;
    for j = round(length(res1(i,:))/2):-1:1    % 从中心往左边遍历
        if res1(i,j)>cond_l(i,1) && res1(i,j)<cond_h(i,1)   %% 判断符合条件的点
            js = js + 1;
        else
            break;
        end
    end
    area_num = [area_num; js*2];  %因为是半边遍历   所以要乘2  %符合条件的点数
    %area_num = [area_num; length(find(res1(i,:)>cond_l(i,1) & res1(i,:)<cond_h(i,1)))];  %符合条件的点数
end
if para.array_num_y==1
    overlayyy = 0;
else
    overlayyy = (paralist.array_num_y-1)*paralist.overlay;
end
% 计算准均匀区域占线圈宽度的百分比
zhunarea = area_num./(paralist.array_num_y*paralist.send_maxR*2/sweeplist.lens-overlayyy);   %准均匀区域占线圈宽度的百分比


% 计算阵列中心区域的互感大小
Mc = [];
for i = 1:r
    m = res1(i, round(c/2-area_num(i,1)/2):round(c/2+area_num(i,1)/2));
    Mc = [Mc; mean(m)];
end

%Mc = res1(:,round(c/2));


% %%优化器是取极小  因此取负数
% zhunarea = -zhunarea;
% Mc = -Mc;

%% 计算互感分布平均值与方差指标
% 按行计算平均值   即计算每个高度下的互感平均值
Mean = mean(res1, 2);
Mean_mean = mean(Mean);
% 按行计算方差   即计算每个高度下的方差波动
Var = var(res1,0,2);
Var_mean = mean(Var);



%% 绘图 互感量
% 计算绕组长度
decay = 0;
for i = 1:paralist.send_N
    r = (paralist.send_maxR-(i-1)*paralist.send_tw)*8;
    decay = decay+r;
end
rd = (paralist.send_N-1)*paralist.send_tw/paralist.send_maxR;
%%绘制单匝Rx的互感计算值
plot_M(sweeplist, paralist, res1,Var,Mean, rd, zhunarea, decay);

%% 计算阵列自感
L_array = cal_unit_L(paralist, sweeplist);

%% 耦合系数
% 假设接收线圈15匝  互感约为单匝的10倍
% res1=res1.*10;
% k = res1(:,:)./sqrt(17.66*L_array);

% 假设接收线圈3层8匝  真实自感72uH  互感约为单匝计算值的14.6倍
res=res1.*14.6;
if canshu5 ==1  %%真实的单元和2x1自感
    L_array = 59.522;
elseif canshu5 ==2
    L_array = 105.41;
end 
k = res(:,:)./sqrt(72*L_array);

%k = 0;
%% 绘图  耦合系数
plot_L(paralist,sweeplist, k,Var,Mean, rd, zhunarea,decay, L_array)


%% 绘图  绘制整个Rx的计算互感
plot_M(sweeplist, paralist, res,Var,Mean, rd, zhunarea, decay);

%% 下面是用于导出数据的代码 用于origin绘图 平时不用！！！
% %单Tx互感计算结果导出
% x = sweeplist.start_p:sweeplist.lens:sweeplist.end_p;
% x = x.*100;
% RESULT = [x', res'];
% % 保存结果到mat 
% save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\single_Tx_MQ.mat','RESULT');

% %双Tx的2x1阵列互感计算结果导出
x = sweeplist.start_p:sweeplist.lens:sweeplist.end_p;
x = x.*100;
RESULT = [x', res'];
% % 保存结果到mat 
% save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\double_Tx_MQ.mat','RESULT');

end
