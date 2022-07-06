%% 计算一匝矩形线圈在指定位置处产生的磁场强度
function [B] = turn_mag_cal(P, L)

% 分别计算前后左右四个有限长度导线组成的一匝线圈产生的磁场
B_R = line_mag_cal('x', P, L, L(1), 1);
B_L = line_mag_cal('x', P, L, -L(1), -1);
B_F = line_mag_cal('y', P, L, L(1), -1);
B_B = line_mag_cal('y', P, L, -L(1), 1);

% 多个导体形成的磁场矢量和
B = B_R + B_L + B_F + B_B;
B = double(B);

end


