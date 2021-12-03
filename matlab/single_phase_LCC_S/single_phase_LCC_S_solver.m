% 单相 LCC/S 电路的元件值求解

syms R1 R2 RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%创建实数符号变量
syms Ir Ip Is Uin zin u_RE Uo

%% 设定电路变量

Uin_d = 50;    %输入电压幅值
r_d = 0.1;   % 电感比
Q_d = 0.1;    % Q值
RL_d = 50;   % 二次侧输出负载
w0_d = 2*pi*100E+3;     % 固有谐振频率
wn_d = 1;         % 实际工作频率与固有谐振频率比值
k_d = 0.623;      %互感
Lp_d = 17.67E-6;    %初级线圈电感量
R1_d = 0;     %一次侧导线电阻
R2_d = 0;     %二次侧导线电阻

% 变量名列表
p_l = [Uin, r, Q, RL, w0, wn, k, Lp, R1, R2];
% 变量带入值列表
newp_l = [Uin_d, r_d, Q_d, RL_d, w0_d, wn_d, k_d, Lp_d, R1_d, R2_d];

%% 求解电路  Q为输入变量    仅含w0, wn, r, Q, RL, k
%res = single_phase_LCC_S_matrix_Q();

%% 求解电路  Lp为输入变量    仅含w0, wn, r, Lp, RL, k
res = single_phase_LCC_S_matrix_Lp();

%% 带入设定变量
L1 =res.L1
L1 = vpa(simplify(subs(res.L1, p_l, newp_l)), 4)
Lp =res.Lp
Lp = vpa(simplify(subs(res.Lp, p_l, newp_l)), 4)
Ls = res.Ls
Ls = vpa(simplify(subs(res.Ls, p_l, newp_l)), 4)
Cpp = res.Cpp
Cpp = vpa(simplify(subs(res.Cpp, p_l, newp_l)), 4)
Cps = res.Cps
Cps = vpa(simplify(subs(res.Cps, p_l, newp_l)), 4)
Css = res.Css
Css = vpa(simplify(subs(res.Css, p_l, newp_l)), 4)
zin = res.zin
zin = vpa(simplify(subs(res.zin, p_l, newp_l)), 4)
Gu = res.Gu
Gu = simplify(subs(res.Gu, [R1, R2], [0, 0]))   % 忽略R1 R2影响  以简化表达式
Gu = vpa(simplify(subs(res.Gu, p_l, newp_l)), 4)
Po = res.Po
Po = simplify(subs(res.Po, [R1, R2], [0, 0]))   % 忽略R1 R2影响  以简化表达式
Po = vpa(simplify(subs(res.Po, p_l, newp_l)), 4)

%% 输入阻抗 zin 幅值 - 频率 随频率 k 变换绘图   （Q变化）
func = abs(res.zin);
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4], k, [0.1, 1], 100, p_l, newp_l);   

%% 输入阻抗 zin 幅值 - 频率 随频率 wn 变换绘图   （Q变化）
func = abs(res.zin);
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3], wn, [0.7, 1.4], 100, p_l, newp_l);   

%% 输入阻抗 zin 幅值 - 相位 随频率 wn 变换绘图   （Q变化）
func = angle(res.zin)*180/pi;
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3], wn, [0.7, 1.4], 100, p_l, newp_l);  

%% 电压增益 Gu 随频率 wn 变换绘图   （Q变化）
func = abs(res.Gu);
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3], wn, [0.7, 1.4], 100, p_l, newp_l);  

%% 电压增益 Gu 随频率 wn 变换绘图   （k变化）
func = abs(res.Gu);
single_phase_LCC_S_parmamer_plot(func, k, [0.1, 0.3, 0.5, 0.7, 0.9, 1], wn, [0.7, 1.4], 100, p_l, newp_l);  

%% 输出功率 Po 随频率 wn 变换绘图   (Q变化)
func = abs(res.Po);
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3, 4, 5, 6], wn, [0.7, 1.4], 100, p_l, newp_l);  

%% 输出功率 Po 随频率 wn 变换绘图 （负载变化）
func = abs(res.Po);
single_phase_LCC_S_parmamer_plot(func, RL, [5, 10, 20, 30, 40, 50, 60], wn, [0.7, 1.4], 100, p_l, newp_l);  

%% 输出功率 Po 随频率 wn 变换绘图 （k变化）
func = abs(res.Po);
single_phase_LCC_S_parmamer_plot(func, k, [0.1, 0.3, 0.5, 0.7, 0.9, 1], wn, [0.7, 1.4], 100, p_l, newp_l);  

%% 输出功率 Po 随 k 变化绘图  （wn变化）
func = abs(res.Po);
single_phase_LCC_S_parmamer_plot(func, wn, [0.7, 0.8, 0.9, 1, 1.1, 1.2], k, [0.1, 1], 100, p_l, newp_l);  





