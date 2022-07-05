%% 根据输入参数计算阵列的磁场分布
function [B] = array_mag_cal(sweeplist, paralist)  % sweep_par 扫描参数  paralist 线圈参数

start_p = sweeplist.start_p;
end_p = sweeplist.end_p;
steps = sweeplist.steps;

fixed_x = sweeplist.fixed_x;
fixed_z = sweeplist.fixed_z;

% 阵列在xy两方向上的阵列数量
ar_y = 1;

% 遍历得到一系列扫描点P
lens = (end_p-start_p)/steps;
P_list = [];
for i = start_p:lens:end_p
    P_list = [P_list; fixed_x,i,fixed_z];
end


% 计算两单元线圈间阵列距离
dupli_dis = paralist.send_maxR*2-paralist.overlay;

P_list_temp = P_list;
B_list = [];

% 计算由阵列引起的P点磁场强度
for i = 1:ar_y
    % 将P点坐标从阵列线圈的坐标系转换至单元阵列的独立坐标系
    P_list_temp(:,1) = P_list(:,1)-paralist.send_maxR;  %x方向
    P_list_temp(:,2) = P_list(:,2)-(i-1)*dupli_dis-paralist.send_maxR;   %y方向
    
    
    [r,c] = size(P_list_temp);    % 读取行r、列c
    temp = [];
    for j = 1:r
        % 计算每一个阵列单元产生的磁场
        b = unit_mag_cal(paralist, P_list_temp(j,:));
        temp = [temp, b];
    end
    B_list(:, :, i)= temp;
end

B = sum(B_list, 3)
end



