% 单相 LCC/S 电路的元件值求解

syms RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%创建实数符号变量
syms Ir Ip Is Uin zin u_RE Uo


% 设定电路变量
Uin_d = 50;    %输入电压幅值
r_d = 0.1;   % 电感比
Q_d = 3;    % Q值
RL_d = 50;   % 二次侧输出负载
w0_d = 2*pi*100E+3;     % 固有谐振频率
wn_d = 1;         % 实际工作频率与固有谐振频率比值
k_d = 0.65;      %互感

% 求解电路
res = single_phase_LCC_S_matrix();

% 带入设定变量
L1 = vpa(simplify(subs(res.L1, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Lp = vpa(simplify(subs(res.Lp, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Ls = vpa(simplify(subs(res.Ls, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Cpp = vpa(simplify(subs(res.Cpp, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Cps = vpa(simplify(subs(res.Cps, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Css = vpa(simplify(subs(res.Css, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
zin = vpa(simplify(subs(res.zin, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Gu = vpa(simplify(subs(res.Gu, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)
Po = vpa(simplify(subs(res.Po, [r, Q, RL, w0, wn, k], [r_d, Q_d, RL_d, w0_d, wn_d, k_d])), 4)

%% 输入阻抗随频率变换绘图

% 输入阻抗 幅值 - 频率 图   改变Q值，即L1
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

% 输入阻抗 相角 - 频率 图   改变Q值，即L1
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

%% 电压增益随频率变换绘图
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

%% 输出功率随频率变换绘图
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
