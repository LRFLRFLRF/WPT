% ���� LCC/S ��·��Ԫ��ֵ���

syms RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%����ʵ�����ű���
syms Ir Ip Is Uin zin u_RE Uo


% �趨��·����
Uin_d = 50;    %�����ѹ��ֵ
r_d = 0.1;   % ��б�
Q_d = 3;    % Qֵ
RL_d = 50;   % ���β��������
w0_d = 2*pi*100E+3;     % ����г��Ƶ��
wn_d = 1;         % ʵ�ʹ���Ƶ�������г��Ƶ�ʱ�ֵ
k_d = 0.65;      %����

% ����·
res = single_phase_LCC_S_matrix();

% �����趨����
L1 = vpa(simplify(subs(res.L1, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Lp = vpa(simplify(subs(res.Lp, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Ls = vpa(simplify(subs(res.Ls, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Cpp = vpa(simplify(subs(res.Cpp, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Cps = vpa(simplify(subs(res.Cps, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Css = vpa(simplify(subs(res.Css, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
zin = vpa(simplify(subs(res.zin, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Gu = vpa(simplify(subs(res.Gu, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Po = vpa(simplify(subs(res.Po, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)

%% �����迹��Ƶ�ʱ任��ͼ

% �����迹 ��ֵ - Ƶ�� ͼ   �ı�Qֵ����L1
figure();
Q_list = [0.2, 0.4, 0.6, 0.8, 1, 2, 3, 4, 5, 6];
color=linspace(0.1,1,length(Q_list));
c_index = 1;
for i=Q_list
    Q_d = i;
    zin_temp = abs(subs(res.zin, [Q, r, w0, RL, k], [Q_d, r_d, w0_d, RL_d, k_d]));
    
    x_list = 0.5:0.01:1.5;
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(zin_temp, wn, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end

% �����迹 ��� - Ƶ�� ͼ   �ı�Qֵ����L1
figure();
Q_list = [0.2, 0.4, 0.6, 0.8, 1, 2, 3];
color=linspace(0.1,1,length(Q_list));
c_index = 1;
for i=Q_list
    Q_d = i;
    zin_temp = angle(subs(res.zin, [Q, r, w0, RL, k], [Q_d, r_d, w0_d, RL_d, k_d]))*180/pi;
    
     x_list = 0.5:0.01:1.5;
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(zin_temp, wn, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end

%% ��ѹ������Ƶ�ʱ任��ͼ
figure();
Q_list = [0.2, 0.4, 0.6, 0.8, 1, 2, 3, 4, 5, 6];
color=linspace(0.1,1,length(Q_list));
c_index = 1;
for i=Q_list
    Q_d = i;
    Gu_temp = simplify(abs(subs(res.Gu, [Q, r, RL, w0, k], [Q_d, r_d, RL_d, w0_d, k_d])));
    
    x_list = 0.95:0.002:1.05;
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(Gu_temp, wn, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end

%% ���������Ƶ�ʱ任��ͼ
figure();
Q_list = [0.2, 0.4, 0.6, 0.8, 1, 2, 3, 4, 5, 6];
color=linspace(0.1,1,length(Q_list));
c_index = 1;
for i=Q_list
    Q_d = i;
    Po_temp = simplify(abs(subs(res.Po, [Q, r, RL, w0, k, Uin], [Q_d, r_d, RL_d, w0_d, k_d, Uin_d])));
    
    x_list = 0.5:0.02:2;
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(Po_temp, wn, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end
