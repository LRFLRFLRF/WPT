
%% 阵列中一个单元线圈的磁通量大小计算
function [Fi, record_new] = unit_fi_cal1(paralist, S, I, record)%

send_tw = paralist.send_tw;
aux_tw = paralist.aux_tw;
send_N = paralist.send_N;
aux_N = paralist.aux_N;
aux_maxR = paralist.aux_maxR;
send_maxR = paralist.send_maxR;



% 计算发射线圈
send_fi_M = 0;
record_new = [];
parfor i=1:send_N
    % 计算每匝产生的互感磁通量和
    a = send_maxR-(i-1)*send_tw;  %根据发射线圈最大半径和匝间距计算每匝的具体半径大小
    L = [a, -a];
    [Fi, b] = turn_fi_cal1(S, L, I, record);
    send_fi_M = send_fi_M + Fi;
    record_new = [record_new; b];
    
    
end

% 计算辅助线圈
aux_fi_M = 0;
parfor i=1:aux_N
    % 计算每匝产生的互感磁通量和
    a = aux_maxR-(i-1)*aux_tw;  %根据发射线圈最大半径和匝间距计算每匝的具体半径大小
    L = [a, -a];
    [Fi, b] = turn_fi_cal1(S, L, I, record);
    aux_fi_M = aux_fi_M + Fi;
    record_new = [record_new; b];
    
end

Fi = send_fi_M + aux_fi_M;

end






