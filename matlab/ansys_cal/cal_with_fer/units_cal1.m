


%% 发射线圈平移时互感磁通计算     ！！！！！！！！！B相和A相交错对齐
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%第一相线圈
%发射线圈参数值设置
offset_d = 0;    %发射线圈位置没有偏移
ps_y_d = 0.5;
u0_d= 4*pi*10^-7;    % 真空磁导率
ur_d = 1;         %铁氧体相对磁导率
rs_d = 9;         %发射线圈半径
i0_d= 1;     
F_temp1 = vpa(simplify(subs(F, [offset, ps_y, u0, ur, rs, i0], [offset_d, ps_y_d, u0_d, ur_d, rs_d, i0_d])), 4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%第二相线圈
%发射线圈参数值设置
offset_d = 10;    %发射线圈位置偏移一半
ps_y_d = 0.5;
u0_d= 4*pi*10^-7;    % 真空磁导率
ur_d = 1;         %铁氧体相对磁导率
rs_d = 9;         %发射线圈半径
i0_d= 1;     
F_temp2 = vpa(simplify(subs(F, [offset, ps_y, u0, ur, rs, i0], [offset_d, ps_y_d, u0_d, ur_d, rs_d, i0_d])), 4);

F_temp = F_temp1 + F_temp2;  %两相总体磁通

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 接收线圈参数值设置
rr_d = 5;
h_d = 15;
F_temp = vpa(simplify(subs(F_temp, [rr, h, Y], [rr_d, h_d, h_d])), 4);


%% A相互感作图
% 接收线圈参数值设置
F_temp1 = vpa(simplify(subs(F_temp1, [rr, h, Y], [rr_d, h_d, h_d])), 4);

figure();
x_lim = [0, par_number*zu_width];
resol = 200;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s];
    t1 = [s_d];
    y_list = [y_list, subs(F_temp1, t, t1)];
end
plot(x_list, y_list);

%% B相互感作图
F_temp2 = vpa(simplify(subs(F_temp2, [rr, h, Y], [rr_d, h_d, h_d])), 4);

figure();
x_lim = [0, par_number*zu_width];
resol = 200;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s];
    t1 = [s_d];
    y_list = [y_list, subs(F_temp2, t, t1)];
end
plot(x_list, y_list);

%% 两相绕组总互感作图
figure();
x_lim = [0, par_number*zu_width];
resol = 200;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s];
    t1 = [s_d];
    y_list = [y_list, subs(F_temp, t, t1)];
end
plot(x_list, y_list);
%ylim([0 2.6E-6]);
