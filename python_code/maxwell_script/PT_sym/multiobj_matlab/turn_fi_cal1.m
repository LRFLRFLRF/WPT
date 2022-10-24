%% 计算一匝矩形线圈在指定位置处产生的磁通大小
% S为接收线圈参数 详见line_mag_cal1
% S = {[4, 0],[4,0],1};  %这只是一个例子便于调试  x为0-4  y为0-4  高为1的接收线圈
% L为导线参数
function [Fi, record_new] = turn_fi_cal1(S, L, I, record)

%% 尝试从历史记录中找该线圈结果
[search_flag, FI_result] = call_from_history(S, L, I, record);

%% 从未计算过
if search_flag == 0
    % 分别计算前后左右四个有限长度导线组成的一匝线圈产生的磁通
    %  原先是line_fi_cal1函数    现在改成line_fi_cal1_new  提高运算速度
    fi_R = line_fi_cal1_new('x', S, L, L(1), I);
    fi_L = line_fi_cal1_new('x', S, L, -L(1), -I);
    fi_F = line_fi_cal1_new('y', S, L, L(1), -I);
    fi_B = line_fi_cal1_new('y', S, L, -L(1), I);
    
    % 多个导体在接收线圈区域内形成的磁通量和
    Fi = fi_R + fi_L + fi_F + fi_B;
    Fi = double(Fi);
    
    %% 将新结果写入
    record_new = [S{1}(1),S{1}(2),S{2}(1),S{2}(2),S{3},L(1),L(2),I,Fi];

else
    %% 曾经计算过 则直接返回结果
    Fi = FI_result;
    record_new = [];  %空结果返回一个空数组
end
end


