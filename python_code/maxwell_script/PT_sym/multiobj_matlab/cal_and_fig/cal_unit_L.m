function [L_array] = cal_unit_L(paralist,sweeplist)

%% 计算发射阵列的自感
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');

% matlab为理想长直导线，导线半径趋于零， 因此计算自感磁通时要偏移一个导线半径
wire_R = 0/100;

% 以各线圈为待计算面得到P_list
P_list = [];
% 计算两单元线圈间阵列距离
dupli_dis = paralist.send_maxR*2-paralist.overlay;
for i = 1:paralist.array_num_y
    
    % 计算不同阵列中心的y坐标
    y = (i-1)*dupli_dis + paralist.send_maxR;
    
    for j = 1:paralist.send_N
        % 计算发射线圈每匝的半径
        plane_R = paralist.send_maxR-(j-1)*paralist.send_tw;
        % 根据每匝的位置和大小生成扫描列表
        P_list = [P_list; sweeplist.fixed_x, y, wire_R, plane_R];
    end
    
    for j = 1:paralist.aux_N
        % 计算辅助线圈每匝的半径
        plane_R = paralist.aux_maxR-(j-1)*paralist.aux_tw;
        % 根据每匝的位置和大小生成扫描列表
        P_list = [P_list; sweeplist.fixed_x, y, wire_R, plane_R];
    end
end

% 将上面得到的P_list待积分面输入  计算每个平面的磁通量
fi_list = array_fi_cal1(paralist, P_list);
% 每匝线圈所围平面的磁通都加在一起  即为发射阵列的自感总磁通
fi_array = sum(fi_list);

% 将结果单位转化成uH
L_array = fi_array*1E+6;

end

