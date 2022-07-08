
%% 阵列中一个单元线圈的磁通量大小计算
function [Fi] = unit_fi_cal1(paralist, S, I)%

send_tw = paralist.send_tw;
aux_tw = paralist.aux_tw;
send_N = paralist.send_N;
aux_N = paralist.aux_N;
aux_maxR = paralist.aux_maxR;
send_maxR = paralist.send_maxR;


% 计算发射线圈
send_fi_M = 0;
for i=1:send_N
    % 计算每匝产生的互感磁通量和
    a = send_maxR-(i-1)*send_tw;  %根据发射线圈最大半径和匝间距计算每匝的具体半径大小
    L = [a, -a];
    send_fi_M = send_fi_M + turn_fi_cal1(S, L, I);
    
end

% 计算辅助线圈
aux_fi_M = 0;
for i=1:aux_N
    % 计算每匝产生的互感磁通量和
    a = aux_maxR-(i-1)*aux_tw;  %根据发射线圈最大半径和匝间距计算每匝的具体半径大小
    L = [a, -a];
    aux_fi_M = aux_fi_M + turn_fi_cal1(S, L, I);
end

Fi = send_fi_M + aux_fi_M;

end






