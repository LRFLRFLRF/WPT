clc;

%坐标XY   磁导率u0 相对磁导率ur  接收线圈距x轴距离h 
syms X Y u0 ur h
syms i0
syms ps_x ps_y s rr rs offset   %第一组发射线圈中心位置坐标  xy    

zu_width = 20;

%% 计算一组发射线圈产生的B场
send = [ps_x-rs, ps_y; ps_x+rs, ps_y;]; %发射线圈两根导体的坐标
I = [i0; -1*i0;];   %发射线圈两根导体的电流

[r,c] = size(send);
B = [];
for j = 1:r
    %%每次循环计算一根导体
    
    %%原始导体对发射铁氧体的B场计算
    [bi, I_j, I_f] = single_point_solver(u0, u0*ur, ps_y, send(j, 1), send(j, 2), I(j, 1));
    B = [B; bi];
    
    
%     %原始导体对接受铁氧体的B场计算
%     bi = single_point_solver(u0, u0*ur, ps_y-h, send(j, 1), send(j, 2), I(j, 1));   %电流为原始导体的电流
%     B = [B; bi];
%     %镜像导体对接受铁氧体的B场计算
%     sendj = send;
%     sendj(:,2) = sendj(:,2)-2*0.5;
%     bi = single_point_solver(u0, u0*ur, -ps_y-h, sendj(j, 1), sendj(j, 2), I_j);    %电流为对发射铁氧体的镜相电流
%     B = [B; bi];
%     %附加导体对接受铁氧体的B场计算
%     bi = single_point_solver(u0, u0*ur, 0.5-15, send(j, 1), send(j, 2), I_f);      %电流为对发射铁氧体的附加电流
%     B = [B; bi];
end
single_B = simplify(sum(B))    %single_B ： 单组发射线圈的B场计算公式

%% 不同多组发射线圈按不同位置放置
par_number = 8; %要放置的组数

B = [];
for i = 1:par_number
    %%根据单组的B场公式，循环计算多组的B
    ps_x_d = i*zu_width - zu_width/2 + offset;  % 每组线圈的中心坐标
    t = [ps_x];
    t1 = [ps_x_d];
    B_temp = subs(single_B, t, t1);
    B = [B; B_temp];   %记录每组的B场
end
multi_B = simplify(sum(B))      %multi_B  :  多组发射线圈的B场公式


%%  计算平移时的互感磁通
rec = [ s-rr, h, s+rr, h;];   %接收线圈的两根导体的坐标位置   s是位移变量

% 接收线圈水平放置，沿x积分B场，计算磁通
Fi = int(multi_B, X)

%带入积分上下限
t = [X];
t1 = [rec(1, 3)];
t2 = [rec(1, 1)];
F = simplify(subs(Fi, t, t1) - subs(Fi, t, t2));

%化简F 保留四位有效值
F = vpa(F,4)









