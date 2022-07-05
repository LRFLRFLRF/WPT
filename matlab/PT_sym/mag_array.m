
sweep_points = 10;
sweep_lim = [0, ]
P = [0,0,1];
for i = 1:sweep_points
    P = [P; ]
end

L1 = [5, -5];
L2 = [2, -2];
% 计算一匝正方形线圈产生的磁场
T1 = turn_mag_cal(P, L1)
T2 = turn_mag_cal(P, L2)




