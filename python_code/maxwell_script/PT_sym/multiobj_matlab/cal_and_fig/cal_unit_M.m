function [res1] = cal_unit_M(paralist,sweeplist)
%% 计算接收线圈在不同位置时的互磁通
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');
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
if end_p~=start_p
    lens = (end_p-start_p)/steps;
else
    lens = 1;   % 如果起始点等于终止点  则设定步长为一个不得0的值   使得列表有一个值输出
end

if end_z~=start_z
    lens_z = (end_z-start_z)/steps_z;
else
    lens_z = 1;
end

P_list = [];
for j = start_z:lens_z:end_z
    for i = start_p:lens:end_p
        P_list = [P_list; fixed_x,i,j, rec_R];
    end
end

% 计算接收区域内的磁通量
res = array_fi_cal1(paralist, P_list);
% 不同传输距离的结果  转换下格式 方便plot
res1 = reshape(res, [steps+1, length(res)/(steps+1)]);
res1 = res1';

% 将结果单位转化成uH
res1 = res1*1E+6;  
end

