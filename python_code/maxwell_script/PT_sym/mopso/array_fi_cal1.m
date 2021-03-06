%% 根据输入参数计算阵列的磁通分布 
 % paralist 线圈参数  P_list 扫描平面的坐标位置 
function [Fi] = array_fi_cal1(paralist, P_list) 

% 设定一个仿真电流
I = 1;

% 计算两单元线圈间阵列距离
dupli_dis = paralist.send_maxR*2-paralist.overlay;

P_list_temp = P_list;
Fi_list = [];



% 计算由阵列引起的P点磁场强度
for i = 1:paralist.array_num_y
    disp(['unit_num:',num2str(i)]);
    
    % 将P点坐标从阵列线圈的坐标系转换至单元阵列的独立坐标系
    P_list_temp(:,1) = P_list(:,1)-paralist.send_maxR;  %x方向
    P_list_temp(:,2) = P_list(:,2)-(double(i)-1)*dupli_dis-paralist.send_maxR;   %y方向
    
    [r,c] = size(P_list_temp);    % 读取行r、列c
    temp = [];

    parfor j = 1:r        
        disp(['plane +1']);
        
        % plane_R待计算平面的半径  
        plane_R = P_list(j,4);
        
        % 计算每一个阵列单元产生的磁场
        S = {[P_list_temp(j,1)+plane_R, P_list_temp(j,1)-plane_R],
            [P_list_temp(j,2)+plane_R, P_list_temp(j,2)-plane_R],
            P_list_temp(j,3)};   % 根据扫描点计算出每个接收线圈的具体参数S
        
        % 计算这个阵列单元与接收单元间的磁通量
        fi = unit_fi_cal1(paralist, S, I);
        temp = [temp, fi];

    end
    Fi_list(:, :, i)= temp;  %记录不同单元阵列的结果
end

% 叠加不同发射单元在接收线圈引起的磁通量  以计算阵列在指定平面区域内的总互磁通量
Fi = sum(Fi_list, 3)

end


