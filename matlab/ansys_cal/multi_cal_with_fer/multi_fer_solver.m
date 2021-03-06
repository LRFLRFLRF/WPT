
%坐标XY   磁导率u0 相对磁导率ur  内两根导线距y轴距离m   外侧两根导线距y轴距离n   接收线圈距x轴距离h   接收线圈沿x轴平移距离s 
syms X Y u0 ur m n h s 
syms L1 L2 d  %双极线圈长   单极线圈长   双极线圈距中心距离
syms a1 b1 a2 b2 a3 b3 a4 b4 i0

%% 计算发射线圈产生的B场

%%单组发射线圈
send = [a1, 0.5; a2, 0.5; a3, 0.5; a4, 0.5;];
I = [i0; -1*i0; i0; -1*i0;];

%%沿x轴复制一组发射线圈
send_copy = send;   %一组四根导线的坐标
send_copy(:,1) = send_copy(:,1)+d+2*n;    %第二组导线坐标 
send = [send; send_copy;]; 

send_copy(:,1) = send_copy(:,1)+d+2*n;    %第三组导线坐标
send = [send; send_copy;]; 

send_copy(:,1) = send_copy(:,1)+d+2*n;    %第四组导线坐标
send = [send; send_copy;]; 

I = [I; I;I;I;];

[r,c] = size(send);
B = [];
for j = 1:r
    %%每次循环计算一根导体
    
    %%原始导体对发射铁氧体的B场计算
    [bi, I_j] = single_point_solver(u0, u0*ur, 0.5, send(j, 1), send(j, 2), I(j, 1));
    B = [B; bi];
    
    %原始导体对接受铁氧体的B场计算
    bi = single_point_solver(u0, u0*ur, 0.5-15, send(j, 1), send(j, 2), I(j, 1));   %电流为原始导体的电流
    B = [B; bi];
    %镜像导体对接受铁氧体的B场计算
    sendj = send;
    sendj(:,2) = sendj(:,2)-2*0.5;
    bi = single_point_solver(u0, u0*ur, -0.5-15, sendj(j, 1), sendj(j, 2), I_j);    %电流为对发射铁氧体的镜相电流
    B = [B; bi];
end
B_sum = sum(B); 



%约束条件
i0_d = 1;   %导线电流
a4_d = n; a1_d = -a4_d; a3_d = m; a2_d = -a3_d;  %导线横坐标
%带入约束
t = [i0, a1, a2, a3, a4];
t1 = [i0_d, a1_d, a2_d, a3_d, a4_d];
B_sum = simplify(subs(B_sum, t, t1))


%%  计算互感磁通
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rec = [ s-L2/2, h, s+L2/2, h;];

% 积分计算磁通
Fi = int(B_sum, X);

[r,c] = size(rec);
F = [];
for i = 1:r
    t = [X];
    t1 = [rec(i, 3)];
    t2 = [rec(i, 1)];
    F = [F;simplify(subs(Fi, t, t1) - subs(Fi, t, t2));];
end
%化简F 并保留四位有效值
F = vpa(simplify(sum(F)),4)



%% 发射线圈平移时互感磁通计算
%发射线圈参数值设置
m_d = 9;
n_d = 34;
u0_d= 4*pi*10^-7;
ur_d = 1000;
F_temp = vpa(simplify(subs(F, [m, n, u0, ur], [m_d, n_d, u0_d, ur_d])), 4);
% 接收线圈参数值设置
L2_d = 30;
h_d = 15;
d_d = 10;

%%作图
figure();
x_lim = [-34, 300];
resol = 100;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s, L2, d, Y, h];
    t1 = [s_d, L2_d, d_d, h_d, h_d];
    y_list = [y_list, subs(F_temp, t, t1)];
end
plot(x_list, y_list);
%ylim([0 2.6E-6]);






