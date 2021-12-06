%坐标XY   磁导率u0  内两根导线距y轴距离m   外侧两根导线距y轴距离n   接收线圈距x轴距离h   接收线圈沿x轴平移距离s 
syms X Y u0 m n h s   
syms L1 L2 d  %双极线圈长   单极线圈长   双极线圈距中心距离
syms a1 b1 a2 b2 a3 b3 a4 b4 i0

%% 计算发射线圈产生的B场

%%单组发射线圈
send = [a1, 0; a2, 0; a3, 0; a4, 0;];
I = [i0; -i0; i0; -i0;];

%%三组发射线圈
send1 = send;
send1(:,1) = send1(:,1)+d+2*n;
send2 = send1;
send2(:,1) = send2(:,1)+d+2*n;
send3 = send2;
send3(:,1) = send3(:,1)+d+2*n;
send = [send; send1;send2;send3;];

I1 = I;
I1(:,1) = I1(:,1)*(1);
I2 = I1;
I2(:,1) = I2(:,1)*(1);
I3 = I2;
I3(:,1) = I3(:,1)*(1);
I = [I; I1; I2; I3;];


D = sqrt((X-send(:,1)).^2 + (Y-send(:,2)).^2);   %xy 到 四个导线的距离矩阵
Bi = u0/(2*pi) * I(:,1).*(X-send(:,1))./D(:,1).^2;   %每一个导线的B
B_sum = sum(Bi);     %B 的矢量和



%约束条件
i0_d = 1;   %导线电流
a4_d = n; a1_d = -a4_d; a3_d = m; a2_d = -a3_d;  %导线横坐标
%带入约束
t = [i0, a1, a2, a3, a4];
t1 = [i0_d, a1_d, a2_d, a3_d, a4_d];
B_sum = simplify(subs(B_sum, t, t1));


%%  计算互感磁通
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%rec = [s-d-L1, h, s-d, h; s+d, h, s+d+L1, h; s-L2/2, h, s+L2/2, h;];   %接收线圈的3个部分的位置
rec = [ s-L2/2, h, s+L2/2, h;];

Fi = int(B_sum, X);

[r,c] = size(rec);
F = [];
for i = 1:r
    t = [X, Y];
    t1 = [rec(i, 3), h_d];
    t2 = [rec(i, 1), h_d];
    F = [F;simplify(subs(Fi, t, t1) - subs(Fi, t, t2));];
end

F = vpa(simplify(sum(F)),4)


%% 计算方差  暴力求解各参数最小方差
% resol = 5;
% m_lim = [1, 11]; 
% resolution = (m_lim(2)-m_lim(1))/resol;
% m_list = m_lim(1):resolution:m_lim(2);
% 
% resol = 5;
% n_lim = [10, 50]; 
% resolution = (n_lim(2)-n_lim(1))/resol;
% n_list = n_lim(1):resolution:n_lim(2);
% 
% resol = 5;
% L2_lim = [10, 110]; 
% resolution = (L2_lim(2)-L2_lim(1))/resol;
% L2_list = L2_lim(1):resolution:L2_lim(2);
% 
% resol = 5;
% d_lim = [0, 20]; 
% resolution = (d_lim(2)-d_lim(1))/resol;
% d_list = d_lim(1):resolution:d_lim(2);
% 
% 
% %%计算各参数组合下F的方差 （s变化）
% mat = [];
% u0_d = 4*pi*10^-7;
% for i = d_list
%     for k = L2_list
%         for p = m_list
%             for q = n_list
%                 y_list = [];
%                 
%                 resol = 6;
%                 s_lim = [q, 3*q]; 
%                 resolution = (s_lim(2)-s_lim(1))/resol;
%                 s_list = s_lim(1):resolution:s_lim(2);
%                 
%                 for l = s_list
%                     t = [L2, s, d, Y, m, n, u0];
%                     t1 = [k, l, i, 15, p, q, u0_d];
%                     temp = sym2poly(simplify(subs(F, t, t1)));
%                     y_list = [y_list; temp;];
%                 end
%                 avg = mean(y_list, 1);
%                 std = sqrt(var(y_list(:,1)))
%                 mat = [mat; i, k, p, q, std, avg;];
% 
%             end
%         end
%     end
% end



%% 发射线圈平移时互感磁通计算

% 发射线圈参数值设置
m_d = 1;
n_d = 10;
u0_d= 4*pi*10^-7;
F = vpa(simplify(subs(F, [m, n, u0], [m_d, n_d, u0_d])), 4);

% 接收线圈参数值设置
L2_d = 10;
h_d = 15;
d_d = 20;

%%作图
figure();
x_lim = [1, 30];
resol = 80;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s, L1, L2, d, Y];
    t1 = [s_d, L1_d, L2_d, d_d, h_d];
    y_list = [y_list, subs(F, t, t1)];
end
plot(x_list, y_list);
ylim([0 4E-7]);




