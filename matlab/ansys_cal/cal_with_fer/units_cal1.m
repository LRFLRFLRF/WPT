


%% ������Ȧƽ��ʱ���д�ͨ����     ������������������B���A�ཻ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��һ����Ȧ
%������Ȧ����ֵ����
offset_d = 0;    %������Ȧλ��û��ƫ��
ps_y_d = 0.5;
u0_d= 4*pi*10^-7;    % ��մŵ���
ur_d = 1;         %��������Դŵ���
rs_d = 9;         %������Ȧ�뾶
i0_d= 1;     
F_temp1 = vpa(simplify(subs(F, [offset, ps_y, u0, ur, rs, i0], [offset_d, ps_y_d, u0_d, ur_d, rs_d, i0_d])), 4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ڶ�����Ȧ
%������Ȧ����ֵ����
offset_d = 10;    %������Ȧλ��ƫ��һ��
ps_y_d = 0.5;
u0_d= 4*pi*10^-7;    % ��մŵ���
ur_d = 1;         %��������Դŵ���
rs_d = 9;         %������Ȧ�뾶
i0_d= 1;     
F_temp2 = vpa(simplify(subs(F, [offset, ps_y, u0, ur, rs, i0], [offset_d, ps_y_d, u0_d, ur_d, rs_d, i0_d])), 4);

F_temp = F_temp1 + F_temp2;  %���������ͨ

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ȧ����ֵ����
rr_d = 5;
h_d = 15;
F_temp = vpa(simplify(subs(F_temp, [rr, h, Y], [rr_d, h_d, h_d])), 4);


%% A�໥����ͼ
% ������Ȧ����ֵ����
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

%% B�໥����ͼ
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

%% ���������ܻ�����ͼ
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
