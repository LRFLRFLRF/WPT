%% 阵列中一个单元线圈的磁场强度计算
function [B] = unit_mag_cal(paralist, P)

send_tw = paralist.send_tw;
send_N = paralist.send_N;
aux_N = paralist.aux_N;
aux_maxR = paralist.aux_maxR;
send_maxR = paralist.send_maxR;

% 计算发射线圈
send_B = 0;
for i=1:send_N
    % 计算n匝在P点产生的磁场矢量和
    a = send_maxR-i*send_tw;  %根据发射线圈最大半径和匝间距计算每匝的具体半径大小
    L = [a, -a];
    send_B = send_B + turn_mag_cal(P, L);
end

% 计算辅助线圈
aux_B = 0;
for i=1:aux_N
    % 计算n匝在P点产生的磁场矢量和
    a = aux_maxR-i*0.25;  %根据发射线圈最大半径和匝间距计算每匝的具体半径大小
    L = [a, -a];
    aux_B = aux_B + turn_mag_cal(P, L);
end

B = send_B + aux_B;

end




