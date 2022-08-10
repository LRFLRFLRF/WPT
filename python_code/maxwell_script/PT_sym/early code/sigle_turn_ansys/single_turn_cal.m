
%% 针对一匝线圈在空间中的磁场分布进行仿真
function [Fi] = single_turn_cal()%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%初始化仿真参数
paralist.send_maxR = 15;%
paralist.overlay = 1.63;
paralist.send_N = 1;
paralist.rec_maxR = 5;
paralist.array_num_y = 2;

sweeplist.start_p = paralist.rec_maxR;
sweeplist.end_p = (paralist.send_maxR*4-paralist.overlay)/2;
sweeplist.steps = 10;
sweeplist.start_z = 2;
sweeplist.end_z = 15;
sweeplist.steps_z = 3;
sweeplist.fixed_x = 15;

I = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
send_tw = paralist.send_tw;
send_N = paralist.send_N;
send_maxR = paralist.send_maxR;


% 计算发射线圈
send_fi_M = 0;
parfor i=1:send_N
    % 计算每匝产生的互感磁通量和
    a = send_maxR-(i-1)*send_tw;  %根据发射线圈最大半径和匝间距计算每匝的具体半径大小
    L = [a, -a];
    send_fi_M = send_fi_M + turn_fi_cal1(S, L, I);
end

end






