%% 根据输入参数计算阵列的磁通分布 
function [B] = array_fi_cal1()  % sweeplist 扫描参数  paralist 线圈参数   sweeplist, paralist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面是一些测试参数  正常时注释掉
sweeplist.start_p = 0;
sweeplist.end_p = 30/100;
sweeplist.steps = 6;
sweeplist.fixed_x = 15/100;
sweeplist.fixed_z = 5/100;

paralist.send_maxR = 15/100;
paralist.send_tw = 0.27/100;
paralist.overlay = 0;
paralist.send_N = 1;
paralist.aux_N = 1;
paralist.aux_maxR = 5/100;
paralist.rec_maxR = 5/100;
paralist.array_num_y = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% 设定一个仿真电流
I = 1;

% 扫描点为接收线圈中心点
start_p = sweeplist.start_p;
end_p = sweeplist.end_p;
steps = sweeplist.steps;

% 固定x z轴坐标  只沿y方向扫描
fixed_x = sweeplist.fixed_x;
fixed_z = sweeplist.fixed_z;

% 接收线圈的半径
rec_R = paralist.rec_maxR;  

% 遍历得到一系列扫描点P
lens = (end_p-start_p)/steps;
P_list = [];
for i = start_p:lens:end_p
    P_list = [P_list; fixed_x,i,fixed_z];
end


% 计算两单元线圈间阵列距离
dupli_dis = paralist.send_maxR*2-paralist.overlay;

P_list_temp = P_list;
Fi_list = [];

% 计算由阵列引起的P点磁场强度
for i = 1:paralist.array_num_y
    % 将P点坐标从阵列线圈的坐标系转换至单元阵列的独立坐标系
    P_list_temp(:,1) = P_list(:,1)-paralist.send_maxR;  %x方向
    P_list_temp(:,2) = P_list(:,2)-(i-1)*dupli_dis-paralist.send_maxR;   %y方向
    
    
    [r,c] = size(P_list_temp);    % 读取行r、列c
    temp = [];
    for j = 1:r
        % 计算每一个阵列单元产生的磁场
        S = {[P_list_temp(j,1)+rec_R, P_list_temp(j,1)-rec_R],
            [P_list_temp(j,2)+rec_R, P_list_temp(j,2)-rec_R],
            P_list_temp(j,3)};   % 根据扫描点计算出每个接收线圈的具体参数S
        
        % 计算这个阵列单元的磁通量
        fi = unit_fi_cal1(paralist, S, I);
        temp = [temp, fi];
    end
    Fi_list(:, :, i)= temp;
end

Fi = sum(Fi_list, 3)


end



