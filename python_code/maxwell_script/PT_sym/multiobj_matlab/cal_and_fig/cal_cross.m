
%% 计算单个发射单元互感特性  并绘图
function [Self_inductance_ratio, Cross_MI_ratio] = cal_cross(canshu1, canshu2, canshu3)
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');
%%设定线圈参数及仿真参数
para.send_maxR = 15; %最大半径15cm
para.send_tw = canshu1;%0.5; %绕组匝间距
para.aux_tw = 0;  %辅助线圈匝间距
para.overlay = canshu2;%10;   %阵列单元重叠度
para.send_N = canshu3;    % 发射线圈匝数
para.aux_N = 0;
para.aux_maxR = 0;%
para.rec_maxR = 5;%     %接收线圈最大半径
para.array_num_y = 2;   % 阵列单元数

sweep.start_p = -10;    % 扫描起始点
%sweep.end_p = para.array_num_y*(2*para.send_maxR-para.overlay)+10;  % 扫描中止点
sweep.end_p = para.array_num_y*2*para.send_maxR - (para.array_num_y-1)*para.overlay+10;  % 扫描中止点
sweep.steps = 15*para.array_num_y;   % 扫描点数
sweep.start_z = 2;    %z方向扫描起始点
sweep.end_z = 8;    %z方向扫描中止点
sweep.steps_z = 3;   %z方向扫描点数
sweep.fixed_x = para.send_maxR;%   %接收线圈的y轴坐标   即收发装置y轴对准

%% 处理函数 这些基本不需要动  就是把前面设定的数据进行一个转化
%% 一些尺寸参数需要除以100  实现m和cm换算
[paralist,sweeplist] = transform_para(para,sweep);


%% 计算阵列整体自感
paralist_copy = paralist;
paralist_copy.array_num_y = 2;
L_array = cal_unit_L(paralist_copy, sweeplist);

%% 计算单个单元的自感
paralist_copy = paralist;
paralist_copy.array_num_y = 1;
L_unit = cal_unit_L(paralist_copy, sweeplist);

%% 计算自感比
Self_inductance_ratio = L_array/L_unit;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 计算单元间交叉互感
res1 = [];
for j = 1:para.send_N
    
    
    %修改扫描参数以计算两单元间互感
    sweep_copy = sweep;
    para_copy = para;
    
    para_copy.array_num_y = 1;
    
    % 计算每匝半径
    R = para_copy.send_maxR-(j-1)*para_copy.send_tw;
    
    para_copy.rec_maxR = R;
    sweep_copy.start_p = 3*para_copy.send_maxR-para_copy.overlay;
    sweep_copy.end_p = sweep_copy.start_p;
    sweep_copy.steps = 0;
    sweep_copy.start_z = 0;
    sweep_copy.end_z = sweep_copy.start_z;
    sweep_copy.steps_z = 0;
    
    %重新进行单位转换
    [paralist_copy,sweeplist_copy] = transform_para(para_copy,sweep_copy);
    
    % 进行单匝与另一单元间互感值计算
    a = cal_unit_M(paralist_copy,sweeplist_copy);
    res1 = [res1, a];
end
% 计算各匝互感总和
res1 = sum(res1);


%% 计算交叉互感比
Cross_MI_ratio = res1/L_unit;

end

